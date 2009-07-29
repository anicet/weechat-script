# - pnotify.rb 
# pnotify.rb is a script for Weechat that sends highlight notifications and private messages to the Prowl notification API.
# see http://prowl.weks.net/
# It uses the ruby gem prowl
# 
# sudo gem install prowl
# cp pnotify.rb ~/.weechat/ruby/autoload/


def load_prowl
 # for mac os x only
 #$: <<
 #  '/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/1.8' <<
 #  '/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/1.8/universal-darwin9.0'

 require 'stringio'
 require 'rubygems'
 require 'prowl'

 # TODO Handle the error more quitly
 old_stdout = $stdout
 $stdout = StringIO.new
 $stdout = old_stdout
end

def weechat_init
 Weechat.register "pnotify", "0.1", "", "Notify user via prowl"
 load_prowl
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
 from, action, dest, msg = split_args args
 from = get_nickname from
 if dest[0] == ?#
   # Do nothing
   # Weechat.print "Public msg"
 else
   prowl_private_message from, msg
 end
 return Weechat::PLUGIN_RC_OK
end

def notify_highlight(server, args)
 # Weechat.print [server, args].inspect
 from, action, dest, msg = split_args args
 from = get_nickname from
 prowl_highlight from, dest, msg
 return Weechat::PLUGIN_RC_OK
end

def prowl_highlight(from, nickname, message)
 title = "Highlight on #{nickname}"
 # TODO Add truncate
 message = "#{from}: #{message}"
 send_prowl(title,message)
end

def prowl_private_message(nickname, message)
 title = "Private message : #{nickname}" 
 # TODO Add truncate
 send_prowl(title,message)
end

def send_prowl(title, message)
  Prowl.send("your apikey here", {
      :application => "Weechat",
      :event => title,
      :description => message
    })
end