str = "0011011111110101"
str_arr = []
str.split("").each_slice(4) do |ary|
	puts ary.class
	puts ary.to_s
	str_arr << ary
	puts str_arr.to_s
end

puts str_arr[0].join("").class
puts str_arr[0].reverse.join("")
