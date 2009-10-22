# - gnotify.rb 
# gnotify.rb is a script for Weechat that sends highlight notifications and private messages to the Growl notification framework. 
# see http://growl.info/
# It uses the ruby gem meow.
# 
# sudo gem install meow
# cp gnotify.rb ~/.weechat/ruby/autoload/
# mkdir ~/.weechat/images/
# cp images/weechat.png ~/.weechat/images/

#for mac os x only
# $: <<
#   '/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/1.8' <<
#   '/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/1.8/universal-darwin10.0'
 
require 'stringio'
require 'rubygems'
gem 'meow'
require 'meow'

def weechat_init
  Weechat.register("gnotify", "plop@example.com","0.2", "GPL3", "Notify user via growl", "", "") 
  image = Meow.import_image File.expand_path("~/.weechat/images/weechat.png")
  @meow = Meow.new('WeeChat', 'Note', image)
  Weechat.hook_signal("weechat_pv", "meow_private_message", "")
  Weechat.hook_signal("weechat_highlight", "meow_highlight", "")
  return Weechat::WEECHAT_RC_OK
end

def meow_highlight(data,signal,msg)
  title = "meow_highlight"
  message = "#{msg}"
  @meow.notify(title, message)
  return Weechat::WEECHAT_RC_OK
end

def meow_private_message(data,signal,msg)
  title = "meow_private_message"
  message = "#{msg}"
  @meow.notify(title, message)
  return Weechat::WEECHAT_RC_OK
end