require 'optparse'
require	'require_all.rb'

#$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib') unless $LOAD_PATH.include?(File.dirname(__FILE__) + '/../lib')

module Asm
	
	puts("Enter in the file you wish to run: ")
	a_file_path = gets
	@the_BCPU	= Asm::Virtual_Machine.new
	@the_Loader	= Asm::Loader.new( @the_BCPU )
	
	the_messages = @the_Loader.load( a_file_path )
	# process the messages
	the_processed_message	= ''
	the_Tohru_Honda	= 0
	the_messages.each { |this_message|
		the_processed_message << this_message << "\n"
		the_Tohru_Honda += 1
	}
end