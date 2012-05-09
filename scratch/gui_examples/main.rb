# This adds the current file's directory to the load path. 
# $: represents the load path (which is an array) and 
# unshift prepends to the beginning of the array.
# Putting at the top so that all our requires needn't worry 
# about the path.
$:.unshift File.dirname(__FILE__)

require 'xrcframemain.rb'

class GuiMain < XrcFrameMain
    def initialize    
        super()
    # Timer for thread pass
    t = Wx::Timer.new(self, 55)
    evt_timer(55) { Thread.pass }
    t.start(20)
    # File Menu - new file
    evt_menu( @mb_fm_new, :on_new_file )
    # File Menu - about
    evt_menu( @mb_fm_about, :on_about )
    # File Menu - close
    evt_menu( @mb_fm_exit, :on_exit )
    # Set Status Bar Text
    self.set_status_text("Idle...",0) 
    self.set_status_text(Time.now.strftime("%B %d, %Y"), 2)
    end
end

# File --> New
def on_new_file

end

# File --> Exit
def on_exit
  close
end

# Help --> About
def on_about
  Wx::about_box(
    :name => self.title,
    :version => "0.1",
    :description => "Assembly Simulator"
  )
end

Wx::App.run do
      GuiMain.new.show
end
