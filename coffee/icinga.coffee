# Description:
#   Icinga based commands for maximum usefulness
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot icinga disable notifications - Disable Icinga notifications
#   hubot icinga enable notifications - Enable Icinga notifications

module.exports = (robot) ->
 robot.respond /icinga disable notifications/i, (msg) ->
    hostname = msg.match[1]
    @exec = require('child_process').exec
    command = "curl -d \"cmd_typ=11&cmd_mod=2\" mon1.15c.lijit.com/cgi-bin/icinga/cmd.cgi -usrv-icinga:y65XEow0XVuI > /dev/null 2>&1"
    msg.send "Notifications disabled"

    @exec command, (error, stdout, stderr) ->
      msg.send error
      msg.send stdout
      msg.send stderr

 robot.respond /icinga enable notifications/i, (msg) ->
    hostname = msg.match[1]
    @exec = require('child_process').exec
    command = "curl -d \"cmd_typ=12&cmd_mod=2\" mon1.15c.lijit.com/cgi-bin/icinga/cmd.cgi -usrv-icinga:y65XEow0XVuI > /dev/null 2>&1"
    msg.send "Notifications enabled"

    @exec command, (error, stdout, stderr) ->
      msg.send error
      msg.send stdout
      msg.send stderr
