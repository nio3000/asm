module Buy
module Hi
	A = 0
	B = 1
	C = 3

	def to_s
		return "%04d" % self.to_s(2)
	end
end
end

module Other
	include ::Buy
	opcodes = Hi.constants
	puts opcodes.to_s
	binary = lambda { |x| "%04d" % x.to_s(2) }
	Ophash = Hash.new
	opcodes.each do |code|
		#ophash[code] = binary.call(code)
		Ophash[code] = binary.call(Hi.const_get(code))
	end
	puts Ophash.to_s
	puts Ophash.class
end
