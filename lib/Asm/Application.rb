=begin
# /lib/Asm/Application.rb
* complete definition of class Asm::Application
=end

=begin
# Asm
* highest-level namespace for the project.
=end
module Asm
=begin
	# Asm::Application
	* a complete and self-contained application object for a BCPU VM
	* derives from Wx::App; implements an application object for a WxRuby application.
=end
	class Application < Wx::App
	public
=begin		Wx::App callbacks
=end
		# WxRuby callback, no need to register; program initialization
		def on_init
			# application-specific initialization
			@the_BCPU	= Asm::Virtual_Machine.new
			@the_Loader	= Asm::Loader.new( @the_BCPU )
			self.set_name( "BCPU" )
			# DOCIT
			Wx::init_all_image_handlers()
			xml	= Wx::XmlResource.get()
			xml.init_all_handlers()
			xml.load( Asm::Magic::GUI::xrc_file )
			# obtain an object for the main sheet in the GUI
			xml.load_frame( @main_GUI_sheet ,Asm::Magic::GUI::top_level )
			# TODO setup the callbacks
			#	Loader
			#		console
			#		filepath
			#evt_text_enter( @main_GUI_sheet.find_window( Asm::Magic::GUI::Loader::filepath ) ) Asm::Wx::Callback.instance_method(:handle_compile_code)
			#	VM
			#		Control
			#			advance n
			# TODO this callback
			# 	evt_???( @main_GUI_sheet.find_window( Asm::Magic::GUI::VM::??? ) ) Asm::Wx::Callback.instance_method(:handle_advance_n)
			#			advance, delay, repeat
			# TODO these callbacks; go, stop
			# 	evt_???( @main_GUI_sheet.find_window( Asm::Magic::GUI::VM::??? ) ) Asm::Wx::Callback.instance_method(:handle_run_forever)
			# 	evt_???( @main_GUI_sheet.find_window( Asm::Magic::GUI::VM::??? ) ) Asm::Wx::Callback.instance_method(:handle_stop_eternity)
			#		Register
			#		Memory
			# TODO these callbacks; scroll up, scroll down, changed lower bound, changed upper bound
			# 	evt_???( @main_GUI_sheet.find_window( Asm::Magic::GUI::VM::??? ) ) Asm::Wx::Callback.instance_method(:handle_???)
			# show the GUI
			@main_GUI_sheet.show
		end
		# WxRuby callback, no need to register; program start
		#def on_run
		#	super
		#	rescue Exception => e
		#	puts e.message
		#	retry
		#end
	end
=begin	# Asm::Wx
	* misc WxRuby code
=end
	module Wx
=begin		# Asm::Wx::Callback
		* WxRuby callbacks
=end
		module Callback
			# WxRuby callback; invokes compilation and posts results to GUI
			#
			# event - instance of Wx::CommandEvent
			#	see 'http://wxruby.rubyforge.org/doc/commandevent.html'
			# 	see 'http://wxruby.rubyforge.org/doc/textctrl.html'
			#
			# Returns nothing
			def handle_compile_code( a_CommandEvent )
				# obtain a file path
				# TODO obtain a file path from the event argument
				a_file_path	= @main_GUI_sheet.find_window( Asm::Magic::GUI::Loader::filepath ).get_value
				# invoke load, capture returned messages
				the_messages	= @the_Loader.load( a_file_path )
				# process the messages
				the_processed_message	= ''
				the_messages.each { |this_message|	the_processed_message << the_messages << '\n'	}
				# post the_messages to the GUI
				@main_GUI_sheet.find_window( Asm::Magic::GUI::Loader::console ).change_value( the_processed_message )
			end
			# WxRuby callback; DOCIT
			#
			# event - instance of ???
			#
			# Returns nothing
			def handle_advance_n( an_Event )
				# TODO implement this callback
			end
			# WxRuby callback; DOCIT
			#
			# event - instance of ???
			#
			# Returns nothing
			def handle_run_forever( an_Event )
				# TODO implement this callback
			end
			# WxRuby callback; DOCIT
			#
			# event - instance of ???
			#
			# Returns nothing
			def handle_stop_eternity( an_Event )
				# TODO implement this callback
			end
		end
	end
end

#require	'Asm/require_all.rb'
# encoding: UTF-8
