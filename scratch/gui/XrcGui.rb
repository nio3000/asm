#!/usr/bin/env ruby

require 'wx'
include Wx

# Application class.
#
class XrcApp < Wx::App

  def on_init
    Wx::init_all_image_handlers()
    xml = Wx::XmlResource.get()
    xml.init_all_handlers()
    xml.load("SimplePanel.xrc")
    #
    # Show the main frame.
    #
        frame = Wx::Frame.new( nil, -1, 'Simple' )
        frame.set_client_size( Wx::Size.new( 200, 200))
        xml.load_panel( frame, 'ID_WXPANEL')
        frame.show()
  end

end

XrcApp.new().main_loop()
