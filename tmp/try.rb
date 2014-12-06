x = gets.to_f
y = gets.to_f

k = 100.0
l = 1.7
s = 0.6

puts l * ([(y - x) + k, 0].max)**s
puts -l * ([(x - y) + k, 0].max)**s
