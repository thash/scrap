# coding: utf-8
require 'rubygems'
require 'weechat'

def weechat_init
  Weechat.register("send-notify", "memerelics", "0.1", "GPL3",
                   "Notify message with using notify-send.", "", "")
  # run_hook_command
  run_hook_signal
  return Weechat::WEECHAT_RC_OK
end

def run_hook_signal
  Weechat.hook_signal("weechat_highlight", "notify_highlight", "")
end

def notify_highlight(data, signal, message)
#  notify data
  notify message
end

def notify message
  from = message.split(" ")[0]
  text = message.gsub(/#{from}\s*/,"")
  system("/usr/bin/notify-send",
         "--icon=/home/hash/git/scrap/weechat_icon.png",
         from, text)
end


__END__

def run_hook_command
  Weechat.hook_command "hoge",
                       "1111111",
                       "2222",
                       "333333",
                       "444444",
                       "hook_command_method", # method name to be called
                       "666666" # 1st argment passed to hook_command_method
end

def hook_command_method(arg1, arg2, arg3)
  Weechat.print("", "--arg1--")
  Weechat.print("", arg1) # 666666
  Weechat.print("", "--arg2--")
  Weechat.print("", arg2) # "0x1c16c70" what is this?
  Weechat.print("", "--arg3--")
  teechat.print("", arg3) # irc command arg (/hoge arg3)
end

