# Description:
#   We're all counting on you
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
module.exports = (robot) ->
  robot.hear /goodluck/i, (msg) ->
    msg.send "http://www.headsallempty.org/goodluck.jpg"
