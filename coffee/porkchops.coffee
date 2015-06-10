# Description:
#   My god did that smell good
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:

module.exports = (robot) ->
  robot.hear /pork chops/i, (msg) ->
    msg.send "https://www.youtube.com/watch?v=5OEqXAzx6zk"
