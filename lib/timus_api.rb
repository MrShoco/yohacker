require "typhoeus"
require "cgi"

class TimusApi
  def self.get_tasks
    request = Typhoeus::Request.new(
      "http://acm.timus.ru/problemset.aspx?space=1&page=all")
    request.run

    response = request.response

    urls = response.body.scan(
      /href="(problem\.aspx\?space\=1\&amp\;num\=.*?)">/im
    ).map { |str| CGI::unescape_html(str[0]) }

    hydra = Typhoeus::Hydra.new(max_concurrency: 40)
    requests = urls.map do |i| 
      request = Typhoeus::Request.new("http://acm.timus.ru/" + i,
                      headers: { Cookie: "Locale=Russian;",
                                 "Accept-Charset" => "utf-8" } )
      hydra.queue(request)
      request
    end

    hydra.run
    hash = []

    requests.each do |req|
      html = req.response.body
      html.force_encoding("UTF-8")
      html = CGI::unescape_html(html)
      regex = html.gsub(/<IMG SRC="/im, "<img src=\"http://acm.timus.ru/").match(/class="problem_title">([0-9]*?)\.\s(.*?)<.*?class="problem_limits">(.*?)<br>(.*?)<.*?id="problem_text">(.*?)<h3 class="problem_subtitle">.*?<\/h3>(.*?)<h3 class="problem_subtitle">.*?<\/h3>(.*?)<(?:(?:div)|(?:h3)) class="problem_s.*?<b>Метки: <\/b>(.*?)<span.*?class="problem_links"><span>.*?([0-9]*?)<\/span>/im)
      hash.push({ id: regex[1], title: regex[2], time_limit: regex[3], 
                  memory_limit: regex[4], statement: regex[5], input: regex[6], 
                  output: regex[7], tags: regex[8], difficulty: regex[9] })
      hash.last[:tags] = hash.last[:tags].scan(/tag=([a-zA-Z]+)">(.*?)<\/a>/im).map{|i|
                                                                  { eng: i[0], rus: i[1]} }
      resp = html.match(/<table class="sample">.*?<\/table>/im)
      if resp
        hash.last[:sample] = resp[0].scan(/intable">(.*?)<\/PRE><\/TD><TD><PRE CLASS="intable">(.*?)<\/PRE>/im).map{|i| { input: i[0].gsub("\n", "<br>"), output: i[1].gsub("\n", "<br>") } }
      else
        hash.last[:sample] = []
      end
    end
    hash
  end
  
  def self.send_task(num, str, lang)
    request = Typhoeus::Request.new(
    "http://acm.timus.ru/submit.aspx?space=1",
    method: :post,
    body: { Source: str,
              Action: "submit",
              SpaceId: "1",
              JudgeId: "118863JJ",
              Language: lang,
              ProblemNum: num },
    headers: {
            Coockie: "AuthorId=n3pOcty7RZY=; ASP.NET_SessionId=zmvv0pf5wupqlejax4lm2nuu" }
    )

    request.run

    response = request.response

    response.headers["X-SubmitID"]
  end

  def self.check_task(num)
    request = Typhoeus::Request.new(
    "http://acm.timus.ru/status.aspx?space=1&author=me",
    headers: {
            Cookie: "ASP.NET_SessionId=zmvv0pf5wupqlejax4lm2nuu; Locale=Russian; Language=28; AuthorID=n3pOcty7RZY=; _ym_visorc_20918869=w" }
    )
    request.run
    html = request.response.body
    resp = html.match(/<TD class="verdict_[^"]+">(.*?)<\/TD>/im)
    if resp
      resp[1].gsub(/<.+?>/, '')
    else
      nil
    end
  end
end
