#!/usr/bin/env ruby
#
# frame.rb - Frame GUI interface
#

#require 'rubygems'
#require File.expand_path(File.dirname(__FILE__) + "/../lib/Asm")

require 'wx'
include Wx

class AppFrame < Frame
    def initialize()
        super(nil, -1, 'Assembly Simulator')
        # First create the controls
        set_menu_bar(setup_menu)
        @my_panel = Panel.new(self)
        @my_label = StaticText.new(@my_panel, -1, 'My Label Text', 
            DEFAULT_POSITION, DEFAULT_SIZE, ALIGN_CENTER)
        @my_textbox = TextCtrl.new(@my_panel, -1, 'Default Textbox Value')
        @my_combo = ComboBox.new(@my_panel, -1, 'Default Combo Text', 
            DEFAULT_POSITION, DEFAULT_SIZE, ['Item 1', 'Item 2', 'Item 3'])
        @my_button = Button.new(@my_panel, -1, 'My Button Text')
        # Bind controls to functions
        evt_button(@my_button.get_id()) { |event| my_button_click(event)}
        # Now do the layout
        @my_panel_sizer = BoxSizer.new(VERTICAL)
        @my_panel.set_sizer(@my_panel_sizer)
        @my_panel_sizer.add(@my_label, 0, GROW|ALL, 2)
        @my_panel_sizer.add(@my_textbox, 0, GROW|ALL, 2)
        @my_panel_sizer.add(@my_combo, 0, GROW|ALL, 2)
        @my_panel_sizer.add(@my_button, 0, GROW|ALL, 2)        
        show()
    end
    
    def my_button_click(event)
        # Your code here
    end
end

class AsmGui < App
    def on_init
        AppFrame.new
    end
end

AsmGui.new.main_loop()
