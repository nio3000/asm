# This code still freezes for me with:
# Gtk-CRITICAL **: gtk_widget_get_direction: assertion `GTK_IS_WIDGET (widget)' failed
# The only relevent links I could find on the issue (related to wx) was:
# http://forums.wxwidgets.org/viewtopic.php?f=23&t=20535
# Leads me to believe that I am forgetting to declare/set something... I've been fighting with it all day. No luck.

# Ignore the temporary changes, I wanted to work primarily on the GUI and didn't have time to fix all the uninitialized constants, NameErrors and other issues.
# The code as it stands works up to the point of GTK failing assertions. Prior tomy changes it wouldn't even run (Ruby errors). Feel free to fix the other problems in references to Asm:: classes...

=begin
# /lib/Asm/Application.rb
* complete definition of class Asm::Application
=end
require 'wx'
include Wx
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
	class Application < ::Wx::App
	public
=begin	Wx::App callbacks
=end
		# WxRuby callback, no need to register; program initialization
		def on_init
			# application-specific initialization
			@the_BCPU	= Asm::Virtual_Machine.new
			@the_Loader	= Asm::Loader.new( @the_BCPU )
			#self.set_name( "BCPU" )
			# DOCIT
			#::Wx::init_all_image_handlers()	# may be depreciated
			xml	= ::Wx::XmlResource.get()
			xml.init_all_handlers()
			xml.load( Asm::Magic::GUI::Names::Xrc_file )
			# obtain an object for the main sheet in the GUI
			@main_GUI_sheet	= xml.load_frame( nil ,Asm::Magic::GUI::Names::Top_level )
			Asm::Boilerplate::raise_unless_type( @main_GUI_sheet ,::Wx::Frame )
			# TODO setup the callbacks
			#	Loader
			#		filepath
			evt_text_enter( @main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::Loader::Filepath ) ) { |event| self.handle_compile_code( event ) }
			#	VM
			#		Control
			#			advance n
			evt_button( @main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::Advance::N::Button ) ) { |event| ... }	# Process a EVT_COMMAND_BUTTON_CLICKED event,when the button is clicked.
			# TODO this callback
			# 	evt_???( @main_GUI_sheet.find_window( Asm::Magic::GUI::VM::??? ) ) Asm::Wx::Callback.instance_method(:handle_advance_n)
			#			advance, delay, repeat
			# TODO these callbacks; go, stop
			# 	evt_???( @main_GUI_sheet.find_window( Asm::Magic::GUI::VM::??? ) ) Asm::Wx::Callback.instance_method(:handle_run_forever)
			# 	evt_???( @main_GUI_sheet.find_window( Asm::Magic::GUI::VM::??? ) ) Asm::Wx::Callback.instance_method(:handle_stop_eternity)
			#		Register
			#		Memory
			evt_text_enter( @main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::Control::Memory::Counter ) ) { | event | self.update_VM_display }
			evt_spinctrl( @main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::Control::Memory::Counter ) ) { | event | self.update_VM_display }
			# TODO these callbacks; scroll up, scroll down, changed lower bound, changed upper bound
			# 	evt_???( @main_GUI_sheet.find_window( Asm::Magic::GUI::VM::??? ) ) Asm::Wx::Callback.instance_method(:handle_???)
			# set features of the GUI
			# * set allowed range on Advance::N::Counter
			@main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::Advance::N::Counter ).set_range( Asm::Magic::Memory::Index::Inclusive::Minimum ,Asm::Magic::Memory::Index::Inclusive::Maximum )
			# * 
			
			Asm::Magic::GUI::Magic::Memory::Window_Size
			# show the GUI
			@main_GUI_sheet.show(true)
		end
		# WxRuby callback, no need to register; program start
		#def on_run
		#	super
		#	rescue Exception => e
		#	puts e.message
		#	retry
		#end
=begin	Wx callbacks
		* need to be instance methods evidently; not 100% sure why, but at least they get access to @main_GUI_sheet
=end
		# DOCIT
		def update_VM_display( force_program_counter_visible = true )
			# write registers
			raw_registers	= @the_BCPU.get_memory_range( ::Asm::Magic::Register::Index::Inclusive::Minimum ,::Asm::Magic::Register::Index::Exclusive::Minimum )
			# TODO process and dispatch the registers
			# move memory window if it isn't contained in the current memory range
			if	force_program_counter_visible
				memory_window_high_bound	= @main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::Control::Memory::Counter ).get_value
				::Asm::Magic::Memory::Index::assert_valid( memory_window_high_bound )
				memory_window_low_bound	= memory_window_high_bound - ( Asm::Magic::GUI::Magic::Memory::Window_Size - 1 )
				::Asm::Magic::Memory::Index::assert_valid( memory_window_low_bound )
				memory_window	= memory_window_low_bound..(memory_window_high_bound-1)
				program_counter	= ::Asm::BCPU::Memory::Location.new( @the_BCPU.get_memory_value( the_program_counter ).the_bits ).to_i
				if	(!memory_window.includes?( program_counter ))
					target	= program_counter
					if	::Asm::Magic::Memory::Index::valid?( program_counter +( Asm::Magic::GUI::Magic::Memory::Window_Size - 1 ))
						target	+= Asm::Magic::GUI::Magic::Memory::Window_Size - 1
					end
					@main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::Control::Memory::Counter ).set_value( program_counter + 1 )
				end
			end
			# write memory
			memory_window_high_bound	= @main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::Control::Memory::Counter ).get_value
			::Asm::Magic::Memory::Index::assert_valid( memory_window_high_bound )
			memory_window_low_bound	= memory_window_high_bound - ( Asm::Magic::GUI::Magic::Memory::Window_Size - 1 )
			::Asm::Magic::Memory::Index::assert_valid( memory_window_low_bound )
			raw_memory	= @the_BCPU.get_memory_range( memory_window_low_bound ,memory_window_high_bound)
			# TODO process and dispatch the memories
		end
		# WxRuby callback; invokes compilation and posts results to GUI
		#
		# event - instance of Wx::CommandEvent
		#	see 'http://wxruby.rubyforge.org/doc/commandevent.html'
		# 	see 'http://wxruby.rubyforge.org/doc/textctrl.html'
		#
		# Returns nothing
		def handle_compile_code( a_CommandEvent )
			# obtain a file path
			a_file_path	= @main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::Loader::Filepath ).get_value
			# invoke load, capture returned messages
			the_messages	= @the_Loader.load( a_file_path )
			# process the messages
			the_processed_message	= ''
			the_Tohru_Honda	= 0
			the_messages.each { |this_message|
				the_processed_message << this_message << "\n"
				the_Tohru_Honda += 1
			}
			the_processed_message << the_Tohru_Honda.to_s << ' messages caught during loading attempt.' << "\n"	# will give output even if no messages arise.
			# post the_messages to the GUI
			the_console	= @main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::Loader::Console )
			Asm::Boilerplate::raise_unless_type( the_console ,::Wx::TextCtrl )
			the_console.change_value( the_processed_message )
		end
		# WxRuby callback; DOCIT
		#
		# event - instance of EVT_COMMAND_BUTTON_CLICKED
		#
		# Returns nothing
		def handle_advance_n( an_Event )
			# obtain necessary info
			number_of_advances	= @main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::Advance::N::Counter ).get_value
			# advance state
			@the_BCPU.advance( number_of_advances )
			# necessary things
			self.update_VM_display
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

#require	'Asm/require_all.rb'
# encoding: UTF-8
