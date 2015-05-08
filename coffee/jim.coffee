# Description:
#   jim is pretty freakin spectacular
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot top n - Report top output of n host
#   hubot iostat n - Report the current iostat of n host
#   hubot cpu n - Report the /proc/cpuinfo of n host
#   hubot df n - Report df output of n host
#   hubot clearmem n - Clears memory errors of Dell host
#   hubot kernel n - Report the kernel version of n host
#   hubot mem n - Report the 'free -m' output of n host

module.exports = (robot) ->
 robot.respond /top (.*)$/i, (msg) ->
    hostname = msg.match[1]
    @exec = require('child_process').exec
    #command = "host #{hostname}"  
    command = "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/root/.ssh/known_hosts #{hostname} top -b -n 1 | grep -A4 \"load\""

    @exec command, (error, stdout, stderr) ->
      msg.send error
      msg.send stdout
      msg.send stderr

 robot.respond /iostat (.*)$/i, (msg) ->
    hostname = msg.match[1]
    @exec = require('child_process').exec
    command = "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/root/.ssh/known_hosts #{hostname} iostat 1 2 | grep -A1 avg-cpu | sed -n '1,3!p'"

    @exec command, (error, stdout, stderr) ->
      msg.send error
      msg.send stdout
      msg.send stderr

 robot.respond /cpu (.*)$/i, (msg) ->
    hostname = msg.match[1]
    @exec = require('child_process').exec
    command = "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/root/.ssh/known_hosts #{hostname} cat /proc/cpuinfo"

    @exec command, (error, stdout, stderr) ->
      msg.send error
      msg.send stdout
      msg.send stderr

 robot.respond /df (.*)$/i, (msg) ->
    hostname = msg.match[1]
    @exec = require('child_process').exec
    command = "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/root/.ssh/known_hosts #{hostname} df -h"

    @exec command, (error, stdout, stderr) ->
      msg.send error
      msg.send stdout
      msg.send stderr

 robot.respond /clearmem (.*)$/i, (msg) ->
    hostname = msg.match[1]
    @exec = require('child_process').exec
    command = "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/root/.ssh/known_hosts #{hostname} /opt/dell/srvadmin/sbin/dcicfg command=clearmemfailures"

    @exec command, (error, stdout, stderr) ->
      msg.send error
      msg.send stdout
      msg.send stderr

 robot.respond /kernel (.*)$/i, (msg) ->
    hostname = msg.match[1]
    @exec = require('child_process').exec
    command = "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/root/.ssh/known_hosts #{hostname} uname -r"

    @exec command, (error, stdout, stderr) ->
      msg.send error
      msg.send stdout
      msg.send stderr

 robot.respond /mem (.*)$/i, (msg) ->
    hostname = msg.match[1]
    @exec = require('child_process').exec
    command = "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/root/.ssh/known_hosts #{hostname} free -m"

    @exec command, (error, stdout, stderr) ->
      msg.send error
      msg.send stdout
      msg.send stderr
