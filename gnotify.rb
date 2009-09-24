# - gnotify.rb 
# pnotify.rb is a script for Weechat that sends highlight notifications and private messages to the Growl notification framework. 
# see http://growl.info/
# It uses the ruby gem meow.
# 
# sudo gem install meow
# cp gnotify.rb ~/.weechat/ruby/autoload/
# mkdir ~/.weechat/images/
# cp images/weechat.png ~/.weechat/images/

def load_meow
 #for mac os x only Snow Leopard
 $: <<
   '/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/1.8' <<
   '/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/1.8/universal-darwin10.0'

 require 'stringio'
 require 'rubygems'

 # TODO Handle the error more quitly
 old_stdout = $stdout
 $stdout = StringIO.new
 gem 'meow'
 require 'meow'
 $stdout = old_stdout
end

def weechat_init
 Weechat.register "gnotify", "0.1", "", "Notify user via growl"
 load_meow
 image = Meow.import_image File.expand_path("~/.weechat/images/weechat.png")
 @meow = Meow.new('WeeChat', 'Note', image)
 Weechat.add_message_handler("privmsg", "notify")
 Weechat.add_message_handler("weechat_highlight", "notify_highlight")
 return Weechat::PLUGIN_RC_OK
end

def get_nickname(user)
 user =~ /^:([^!]+)/
 $1
end

def split_args(args)
 args = args.split(/\s+/, 4)
 args[-1] = args.last[1..-1]
 args
end

def notify(server, args)
 # args = args.split(/\s+/, 4)
 # Weechat.print args.inspect
 # from = get_nickname args.first
 # dest = args[3]
 # msg = args.last[1..-1]
 # from, action, dest, msg = args.split(/\s+/, 4)
 from, action, dest, msg = split_args args
 from = get_nickname from
 # Weechat.print [from, action, dest, msg].inspect
 if dest[0] == ?#
   # Do nothing
   # Weechat.print "Public msg"
 else
   meow_private_message from, msg
 end
 return Weechat::PLUGIN_RC_OK
end

def notify_highlight(server, args)
 # Weechat.print [server, args].inspect
 from, action, dest, msg = split_args args
 from = get_nickname from
 meow_highlight from, dest, msg
 return Weechat::PLUGIN_RC_OK
end

def meow_highlight(from, nickname, message)
 title = "Highlight on #{nickname}"
 # TODO Add truncate
 message = "#{from}: #{message}"
 @meow.notify(title, message)
 return Weechat::PLUGIN_RC_OK
end

def meow_private_message(nickname, message)
 title = "Privmsg from #{nickname}"
 # TODO Add truncate
 @meow.notify(title, message)
end