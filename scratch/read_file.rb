#!/usr/bin/env ruby
# Just a test snippet to make sure I'm doing this right 
# before I incorporate it into the code. ;) --dap023
filename = ARGV.first

file = File.open(filename, 'r')

lc = 1
file.each_line do |line|
    print "%02d #{line}" % lc
    lc += 1
end
