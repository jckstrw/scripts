# Description:
#   Dougme is pretty freakin spectacular
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot doug me - Receive a Doug
#   hubot suchnick - Receive a Nick (?)

images =
  doug_list: [
    "http://www.headsallempty.org/doug.jpg",
    "http://www.headsallempty.org/pensive_doug.jpg",
    "http://www.headsallempty.org/shy_doug.jpg",
    "http://www.headsallempty.org/doug_car_go.jpg",
    "http://www.headsallempty.org/fuzzy_doug.jpg",
    "http://www.headsallempty.org/yellow_doug.jpg",
    "http://www.headsallempty.org/phone_doug.jpg",
    "http://www.headsallempty.org/cakeday_doug.jpg",
  ]

module.exports = (robot) ->
  robot.hear /doug me/i, (msg) ->
    type = images.doug_list
    msg.send msg.random type

module.exports = (robot) ->
  robot.hear /suchnick/i, (msg) ->
    msg.send "http://www.headsallempty.org/suchnick.png"

module.exports = (robot) ->
  robot.hear /googlysuchnick/i, (msg) ->
    msg.send "http://www.headsallempty.org/suchnickeyes.jpeg"
