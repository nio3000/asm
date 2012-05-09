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
	module	::Asm::Magic::GUI::Colour
		Output_register	= ::Wx::GREEN
		Input_register	= ::Wx::BLUE
		Program_counter	= ::Wx::RED
		Default	= ::Wx::WHITE
	end
	class RunTimer < ::Wx::Timer
		def notify
			if @stopped == true
				@timer.stop()
				@main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::Control::Run::Counter ).enable()
			else
				@the_BCPU.advance_once
				self.update_VM_display
			end
		end
	end
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
			@stopped    = true
			@timer = RunTimer.new
			#::Wx::init_all_image_handlers()	# may be depreciated
			xml	= ::Wx::XmlResource.get()
			xml.init_all_handlers()
			xml.load( Asm::Magic::GUI::Names::Xrc_file )
			# obtain an object for the main sheet in the GUI
			@main_GUI_sheet	= xml.load_frame( nil ,Asm::Magic::GUI::Names::Top_level )
			Asm::Boilerplate::raise_unless_type( @main_GUI_sheet ,::Wx::Frame )
			# set features of the GUI
			# * set allowed range on ::Asm::Magic::GUI::Names::VM::Control::Advance::Run::Counter
			@main_GUI_sheet.find_window_by_name( ::Asm::Magic::GUI::Names::VM::Control::Advance::Run::Counter ).set_range( 1 ,60 * 10 )
			# * set allowed range on Advance::N::Counter
			@main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::Control::Advance::N::Counter ).set_range( 1 ,Asm::Magic::Memory::Index::Inclusive::Maximum )
			# * set allowed range on Memory::Counter
			@main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::Control::Memory::Counter ).set_range( Asm::Magic::Memory::Index::Inclusive::Minimum + Asm::Magic::GUI::Magic::Memory::Window_size - 1 ,Asm::Magic::Memory::Index::Inclusive::Maximum )
			# * set background colours of registers & declare special registers
			# 	* default (will be overridden for special registers)
			(::Asm::Magic::Register::Index::Inclusive::Minimum..::Asm::Magic::Register::Index::Inclusive::Maximum).each do |index|
				@main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::State::Registers[index] ).set_background_colour( ::Asm::Magic::GUI::Colour::Default )
			end
			# 	* input registers
			if	( true )
				description	= ''
				::Asm::Magic::Register::Indicies::Input_registers.each do |index|
					@main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::State::Registers[index] ).set_background_colour( ::Asm::Magic::GUI::Colour::Input_register )
					description << 'R' << index.to_s << ' '
				end
				@main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::Legend::Input ).change_value( description )
				@main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::Legend::Input ).set_background_colour( ::Asm::Magic::GUI::Colour::Input_register )
			end
			# 	* output registers
			if	( true )
				description	= ''
				::Asm::Magic::Register::Indicies::Output_registers.each do |index|
					@main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::State::Registers[index] ).set_background_colour( ::Asm::Magic::GUI::Colour::Output_register )
					description << 'R' << index.to_s << ' '
				end
				@main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::Legend::Output ).change_value( description )
				@main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::Legend::Output ).set_background_colour( ::Asm::Magic::GUI::Colour::Output_register )
			end
			# 	* program counter register
			@main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::State::Registers[::Asm::Magic::Register::Index::Program_counter] ).set_background_colour( ::Asm::Magic::GUI::Colour::Program_counter )
			@main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::Legend::PC ).change_value( 'R' << ::Asm::Magic::Register::Index::Program_counter.to_s )
			@main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::Legend::PC ).set_background_colour( ::Asm::Magic::GUI::Colour::Program_counter )
			# setup the callbacks
			#	Loader
			#		filepath
			evt_text_enter( @main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::Loader::Filepath ) ) { |event| self.handle_compile_code( event ) }
			#	VM
			#		Control
			#			advance n
			#raise @main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::Control::Advance::N::Button ).inspect( )
			evt_button( @main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::Control::Advance::N::Button ) ) { |event| self.handle_advance_n( event ) }	# Process a EVT_COMMAND_BUTTON_CLICKED event,when the button is clicked.
			#raise 'sdgsdg' unless @main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::Control::Advance::N::Button ).get_evt_handler_enabled()
			#			advance, delay, repeat
			evt_button( @main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::Control::Advance::Run::Button ) ) { |event| self.handle_go_stop_button( event ) }
			#@main_GUI_sheet.evt_button(Wx::ID_ANY) { raise 'some button was pressed' }
			#		Register
			#		Memory
			evt_text_enter( @main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::Control::Memory::Counter ) ) { | event | self.update_VM_display( false ) }
			evt_spinctrl( @main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::Control::Memory::Counter ) ) { | event | self.update_VM_display( false ) }
			# show the GUI
			@main_GUI_sheet.show(true)
			#return
		end
		def on_run
			super
			rescue Exception => e
				puts '' << e.message << e.backtrace.to_s
			rescue Asm::Boilerplate::Exception::Misaka_Mikoto => the_railgun
				puts '' << the_railgun.message << the_railgun.backtrace.to_s
			retry
		end
=begin	Wx callbacks
		* need to be instance methods evidently; not 100% sure why, but at least they get access to @main_GUI_sheet
=end
		# DOCIT
		def process_memory_entry( a_memory_index ,a_raw_memory_value )
			temp	= ::Asm::BCPU::Word.new( a_raw_memory_value.the_bits )
			return	'A' << a_memory_index.to_s << ' |-> 0b' << temp.to_s << "\nd" << temp.to_i( true ,false ).to_s << '; d' << temp.to_i( false ,true ).to_s << '; "' << ::Asm::Magic::ISA.machine_code_to_String(a_raw_memory_value) << '"'
		end
		# DOCIT
		def process_register_entry( a_register_index ,a_raw_memory_value )
			temp	= ::Asm::BCPU::Word.from_Bitset( a_raw_memory_value.the_bits )
			return	'R' << a_register_index.to_s << ' |-> 0b' << temp.to_s << "; d" << temp.to_i( true ,false ).to_s << '; d' << temp.to_i( false ,true ).to_s
		end
		# DOCIT
		def update_VM_display( force_program_counter_visible = true )
			# info
			program_counter_value	= @the_BCPU.get_memory_value( Asm::Magic::Register::Location::Program_counter )
			program_counter	= ::Asm::BCPU::Memory::Location.from_binary_String( program_counter_value.the_bits.to_s ).to_i
			# write registers
			raw_registers	= @the_BCPU.get_memory_range( ::Asm::Magic::Register::Index::Inclusive::Minimum ,::Asm::Magic::Register::Index::Exclusive::Maximum )
			for index in 0..(raw_registers.size - 1)
				raise Asm::Boilerplate::Exception::Misaka_Mikoto.new( 'aregaerghaerhaerh (incoherent rage error)' << raw_registers.size.to_s << '==' << (::Asm::Magic::Register::Index::Exclusive::Maximum - ::Asm::Magic::Register::Index::Inclusive::Minimum).to_s ) unless (raw_registers.size == (::Asm::Magic::Register::Index::Exclusive::Maximum - ::Asm::Magic::Register::Index::Inclusive::Minimum))
				processed_version	= self.process_register_entry( ::Asm::Magic::Register::Index::Inclusive::Minimum + index ,raw_registers[index] )
				@main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::State::Registers[index] ).change_value( processed_version )
			end
			# move memory window if the program counter isn't contained in the current memory range
			if	force_program_counter_visible
				memory_window_high_bound	= @main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::Control::Memory::Counter ).get_value
				::Asm::Magic::Memory::Index::assert_valid( memory_window_high_bound )
				memory_window_low_bound	= memory_window_high_bound - ( Asm::Magic::GUI::Magic::Memory::Window_size - 1 )
				::Asm::Magic::Memory::Index::assert_valid( memory_window_low_bound )
				memory_window	= memory_window_low_bound..(memory_window_high_bound-1)
				if	(!memory_window.include?( program_counter ))
					target	= program_counter
					temp	= Asm::Magic::GUI::Magic::Memory::Window_size - 3
					if	::Asm::Magic::Memory::Index::valid?( program_counter + temp )
						target	+= temp
					end
					@main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::Control::Memory::Counter ).set_value( target )
				end
			end
			# write memory
			memory_window_high_bound	= @main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::Control::Memory::Counter ).get_value
			::Asm::Magic::Memory::Index::assert_valid( memory_window_high_bound )
			memory_window_low_bound	= memory_window_high_bound - ( Asm::Magic::GUI::Magic::Memory::Window_size - 1 )
			::Asm::Magic::Memory::Index::assert_valid( memory_window_low_bound )
			raw_memory	= @the_BCPU.get_memory_range( memory_window_low_bound ,memory_window_high_bound + 1 )
			for index in 0..(raw_memory.size - 1)
				raise Asm::Boilerplate::Exception::Misaka_Mikoto.new( 'aregaerghaerhaerh (incoherent rage error)' << raw_memory.size.to_s << '==' << Asm::Magic::GUI::Magic::Memory::Window_size.to_s ) unless (raw_memory.size == Asm::Magic::GUI::Magic::Memory::Window_size)
				processed_version	= self.process_memory_entry( memory_window_low_bound + index ,raw_memory[index] )
				@main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::State::Memories[index] ).change_value( processed_version )
				if (memory_window_low_bound + index) == program_counter
					@main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::State::Memories[index] ).set_background_colour( ::Asm::Magic::GUI::Colour::Program_counter )
				else
					@main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::State::Memories[index] ).set_background_colour( ::Asm::Magic::GUI::Colour::Default )
				end
			end
			return
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
			# post new VM state to the GUI
			self.update_VM_display
			return
		end
		# WxRuby callback; DOCIT
		#
		# event - instance of EVT_COMMAND_BUTTON_CLICKED
		#
		# Returns nothing
		def handle_advance_n( an_Event )
			# obtain necessary info
			number_of_advances	= @main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::Control::Advance::N::Counter ).get_value
			raise Asm::Boilerplate::Exception::Misaka_Mikoto.new( 'jiiiiiiiiiiiiiiiiiiiiiiii' ) unless number_of_advances > 0
			# advance state
			@the_BCPU.advance( number_of_advances )
			# necessary things
			self.update_VM_display
			#puts @the_BCPU.inspect + ' ' + @the_Loader.the_Virtual_Machine.inspect
			return
		end
		# WxRuby callback; DOCIT
		#
		# event - instance of ???
		#
		# Returns nothing
		def handle_go_stop_button( an_Event )
			@stopped = !@stopped
			if @stopped == false
				@main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::Control::Run::Counter ).disable()
				temp = @main_GUI_sheet.find_window_by_name( Asm::Magic::GUI::Names::VM::Control::Run::Counter ).get_value * 1000
				@timer.start(temp)
			end
			return
		end
	end
end

# encoding: UTF-8
