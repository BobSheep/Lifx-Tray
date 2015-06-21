#!/usr/bin/ruby


require 'gtk3'
require 'lifx'

class LifxTray
  def initialize
    super
    init_ui
  end
  
  def init_ui
    
    si = Gtk::StatusIcon.new
    si.stock  = Gtk::Stock::DIALOG_INFO
    
    menu = Gtk::Menu.new
    quit = Gtk::ImageMenuItem.new(Gtk::Stock::QUIT)
    pink = Gtk::MenuItem.new "Pink"
    white = Gtk::MenuItem.new "White"
    warm = Gtk::MenuItem.new "Warm White"

    wmenu = Gtk::Menu.new
    whitem = Gtk::MenuItem.new "White"
    whitem.set_submenu wmenu
    

    lifx = LIFX::Client.lan
    lifx.discover!
    
    light = lifx.lights.first
    
    
    menu.append(pink)
    pink.signal_connect('activate'){
      light.set_color(LIFX::Color.hsb(310,0.9,0.9))
    }
    
    menu.append(whitem)
    wmenu.append(white)
    white.signal_connect('activate'){
      light.set_color(LIFX::Color.white)
    }
    
    wmenu.append(warm)
    warm.signal_connect('activate'){
      light.set_color(LIFX::Color.hsbk(0,0,0.8,2700))
    }
    
    quit.signal_connect('activate'){ Gtk.main_quit }
    menu.append(quit)
    menu.show_all
    
    si.signal_connect('activate'){
      if light.on?
        light.turn_off!
    else
      light.turn_on!
      end
    }
    
    
    si.signal_connect('popup-menu') do |icon, button, time|
      menu.popup(nil, nil, button, time)
    end
    
  end
end

Gtk.init
tray = LifxTray.new
Gtk.main

