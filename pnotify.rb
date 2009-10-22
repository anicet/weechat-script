# - pnotify.rb 
# pnotify.rb is a script for Weechat that sends highlight notifications and private messages to the Prowl notification API.
# see http://prowl.weks.net/
# It uses the ruby gem prowl
# 
# sudo gem install prowl
# cp pnotify.rb ~/.weechat/ruby/autoload/

def load_prowl
 require 'stringio'
 require 'rubygems'
 require 'prowl'

 #for mac os x only
 $: <<
   '/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/1.8' <<
   '/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/1.8/universal-darwin10.0'

 # TODO Handle the error more quitly
 old_stdout = $stdout
 $stdout = StringIO.new
 $stdout = old_stdout
end

def weechat_init
 Weechat.register("pnotify","plop@example.com", "0.2", "GPL3", "Notify user via prowl", "", "")
 load_prowl
 Weechat.hook_signal("weechat_pv","prowl_private_message", "")
 Weechat.hook_signal("weechat_highlight", "prowl_highlight", "")
 return Weechat::WEECHAT_RC_OK
end


def prowl_highlight(data, signal, msg)
 title = "Highlight on #{data} #{signal}"
 message = "#{msg}"
 send_prowl(title,message)
 return Weechat::WEECHAT_RC_OK
end

def prowl_private_message(data, signal, msg)
 title = "Private message #{data} #{signal}:" 
 message = "#{msg}" 
 send_prowl(title,message)
 return Weechat::WEECHAT_RC_OK
end

def send_prowl(title, message)
  Prowl.add("your api key here", {
      :application => "Weechat",
      :event => title,
      :description => message
    })
end