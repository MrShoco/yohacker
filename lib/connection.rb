require 'sinatra/activerecord'

class Connection
  def self.connect_db(type)
    if (type=="production")
      ActiveRecord::Base.establish_connection(
        "postgres://tejkkggmaitpak:d44bIuW9kF2VMi4Efa0SMQUzIQ@ec2-54-225-239-184.compute-1.amazonaws.com:5432/d9283m5h5jq35a"
      )
    else
      ActiveRecord::Base.establish_connection(
        :adapter => "sqlite3",  
        :database => "db/yohacker.db"
      )
    end
  end
end
