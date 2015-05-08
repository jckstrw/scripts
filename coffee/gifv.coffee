# Description:
#   Halbot doesn't like gifv and neither do we 
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   Halbot gifv URL - Any gifv links will be rewritten to gif links to help facilitate laughter


module.exports = (robot) ->
 robot.hear /\bhttp\S*?gifv\b/i, (msg) ->
     bad_url = msg.match[0]
     bad_url2 = bad_url.substring(0, bad_url.length - 1);
     @exec = require('child_process').exec
     command = "echo Bazinga!: \"#{bad_url2}\" "
     @exec command, (error, stdout, stderr) ->
      msg.send error
      msg.send stdout
      msg.send stderr

