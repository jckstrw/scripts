# Description:
#   suchnick is pretty freakin spectacular too
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot suchnick - Receive a Nick (?)

module.exports = (robot) ->
  robot.hear /suchnick/i, (msg) ->
    msg.send "http://www.headsallempty.org/suchnick.png"
