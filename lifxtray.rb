#!/usr/bin/ruby


require 'gtk3'
require 'lifx'

class LifxTray
  def initialize
    super

    lifx = LIFX::Client.lan
    lifx.discover!
    @light = lifx.lights.first

    init_ui
  end
  
  def init_ui
    
    si = Gtk::StatusIcon.new
    
    menu = Gtk::Menu.new
    colour = Gtk::MenuItem.new "Colour"
    pink = Gtk::MenuItem.new "Pink"

    wmenu = Gtk::Menu.new
    whitem = Gtk::MenuItem.new "White"
    whitem.set_submenu wmenu

    white = Gtk::MenuItem.new "Cool White"
    warm = Gtk::MenuItem.new "Warm White"

    sep = Gtk::SeparatorMenuItem.new
    quit = Gtk::MenuItem.new "Quit"

    menu.append(colour)
    colour.signal_connect('activate'){
      choose_colour
    }
    
    menu.append(pink)
    pink.signal_connect('activate'){
      @light.set_color(LIFX::Color.hsb(310,0.9,0.9))
    }
    
    menu.append(whitem)
    wmenu.append(white)
    white.signal_connect('activate'){
      @light.set_color(LIFX::Color.white)
    }
    
    wmenu.append(warm)
    warm.signal_connect('activate'){
         @light.set_color(LIFX::Color.hsbk(0,0,0.8,2700))
    }

    menu.append(sep)
    quit.signal_connect('activate'){ Gtk.main_quit }
    menu.append(quit)
    menu.show_all
    
    si.signal_connect('activate'){
      if @light.on?
        @light.turn_off!
      else
        @light.turn_on!
      end
    }
    
    si.signal_connect('popup-menu') do |icon, button, time|
      menu.popup(nil, nil, button, time)
    end
    
  end

  def choose_colour

    cdia = Gtk::ColorSelectionDialog.new :title => "Pick a color"
    response = cdia.run
    
    if response == Gtk::ResponseType::OK
      colorsel = cdia.color_selection
      col = colorsel.current_rgba
      @light.set_color(
        LIFX::Color.rgb(col.red * 255, col.green * 255, col.blue * 255)
      )
    end
    cdia.destroy
  end
  
end



Gtk.init
tray = LifxTray.new
Gtk.main

