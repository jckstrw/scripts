#!/usr/bin/env python

import pygeoip,pexpect,getpass
import urllib, os,sys,re
from datetime import date,timedelta
import operator,smtplib
from email.MIMEMultipart import MIMEMultipart
from email.MIMEBase import MIMEBase
from email.MIMEText import MIMEText
from email.Utils import COMMASPACE, formatdate
from email import Encoders

gi = pygeoip.GeoIP('Geo.dat', pygeoip.MEMORY_CACHE)

def dupes(dupedList):
   
   #uniqueSet = set(item for item in dupedList)
   uniqueSet = {}
   for item in dupedList:
	if uniqueSet.has_key(item):
		uniqueSet[item]['cnt'] += 1
	else:
		uniqueSet[item] = {
			'cnt': 1
		}
   
   #print "Counting ip overlap"
   #return [(item, dupedList.count(item)) for item in uniqueSet]a
   return uniqueSet

def send_mail(send_from, send_to, subject, text, atts=[], server="localhost"):
        assert type(send_to)==list
        assert type(atts)==list

        msg = MIMEMultipart()
        msg['From'] = send_from
        msg['To'] = COMMASPACE.join(send_to)
        msg['Date'] = formatdate(localtime=True)
        msg['Subject'] = subject

        msg.attach( MIMEText(text) )

        for f in atts:
                part = MIMEBase('application', "octet-stream")
                part.set_payload( open(f,"rb").read() )
                Encoders.encode_base64(part)
                part.add_header('Content-Disposition', 'attachment; filename="%s"' % os.path.basename(f))
                msg.attach(part)

        smtp = smtplib.SMTP(server)
        smtp.sendmail(send_from, send_to, msg.as_string())
        smtp.close()

def ssh_command (user, host, password, command):

   ssh_newkey = 'Are you sure you want to continue connecting'
   child = pexpect.spawn('ssh -l %s %s %s'%(user,host,command),timeout=90)
   i = child.expect([pexpect.TIMEOUT, ssh_newkey, 'password: '])
   if i == 0: # Timeout
        print 'ERROR!'
        print 'SSH could not login. Here is what SSH said:'
        print child.before, child.after
        return None
   if i == 1: # SSH does not have the public key. Just accept it.
        child.sendline ('yes')
        child.expect ('password: ')
        i = child.expect([pexpect.TIMEOUT, 'password: '])
        if i == 0: # Timeout
            print 'ERROR!'
            print 'SSH could not login. Here is what SSH said:'
            print child.before, child.after
            return None       
   child.sendline(password)
   return child


def ssh_parser():
   ec2 = 0
   #print "Parsing IPs"
   f1 = open("ip-temp.log")
   f2 = open("ip-tmp.log",'w')
   yesterday = date.today() - timedelta(1)
   yeststr = yesterday.strftime('%d/%b')
   for x in f1.readlines():
         try:
            if re.search(yeststr,x):
            	ip = str.split(x," ")[0]
            	ValidIpAddressRegex = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$";
            	if re.match(ValidIpAddressRegex,ip.strip() ):
                  f2.write(ip + "\n")
         except:
            ec2+= 1

   f2.close()

   #print "Parse complete- parse errors: " + str(ec2)

def parser():
    ec2 = 0
    if (sys.stdin):
        print "Parsing IPs"
        f2 = open("ip-tmp.log",'w')
        for x in sys.stdin.readlines():
            try:
                ip = str.split(x)[0]
                ValidIpAddressRegex = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$";
                if re.match(ValidIpAddressRegex,ip.strip() ):
                    f2.write(ip + "\n")
            except:
               ec2+= 1
     
        f2.close()
    print "Parse complete- parse errors: " + str(ec2)

def genArray():
   ec= 0
   #print "Geo-lookup started"
   f = open("ip-tmp.log")
   points = []
   for x in f.readlines():
       ipdata = gi.record_by_addr(str.strip(x))
       try:
           city = ipdata['city']
           state = ipdata['region_name']
           country = ipdata['country_code']
           if (country =="US"):
               title = city +" "  + state + " " + country 
           else:
               title = city + " " + country
           lat = str(ipdata['latitude'])
           long = str(ipdata['longitude'])
           loc = lat,long,title

           points.append(loc)
       except:
           ec += 1
           pass
   f.close()
   #print "sorting geo points"
   #print "Geolookup completed - lookup errors:" + str(ec)
   return points



def html():
    f = open("output.html")
    data = f.read()
    f.close()
    return data

def formatter(data,outputfile):
   rows = len(data)
   #print "Outputting file"
   body = ""
   for x in range(0,rows):  
     line  = data[x]
     lat  = line[0][0]
     lon = line[0][1]
     city= line[0][2].replace("'","")
     count = line[1]['cnt']
     fmt1 = "data.setValue("+str(x)+", 0, " + lat+ ");"
     fmt2 = "data.setValue("+str(x)+", 1, " + lon+ ");"
     fmt3 = "data.setValue("+str(x)+", 2, " + str(count) + ");"
     fmt4 = "data.setValue("+str(x)+", 3, '" + city + "');"

     fmtstr = fmt1 + "\n" + fmt2 + "\n" + fmt3 + "\n" + fmt4 + "\n"
     body += fmtstr
   f = open(outputfile,"w")
   myhtml = open("output.html").read()
   lines = str.replace(myhtml,"%%rows%%",str(rows))
   line = lines.replace("%%rowcontents%%",body)
   f.write(line)
   print "Completed outputting html file to " + outputfile 
   f.close()

def sshit():
   host = 'oops.lijit.com'
   user = 'dweiss'
   password = ''
   #password = getpass.getpass('Password:')
   child = ssh_command (user, host, password, "grep ajs.php /var/log/haproxy.log /var/log/haproxy.log.1")
   temp_file = open("ip-temp.log","w")
   child.logfile = temp_file
   child.expect(pexpect.EOF)
   #print child.before

try:
    outputfile = sys.argv[1]
    top = sys.argv[2]
    
except:
    outputfile = "map.html"
#grabs ip's
#sshit()
parser()
points = genArray()
allpoints = dupes(points)
#grabs and sorts ips
#print "Starting sort"
toplocs = [(the_key,allpoints[the_key]) for the_key in sorted(allpoints,key=allpoints.get,reverse=True)[0:int(top)]]
#print toplocs
#outputs files
formatter(toplocs,outputfile)
#cleanup
#print os.getcwd()
#os.chdir("/opt/app/geo_hot_ssh")
#print os.getcwd()
#os.remove("ip-tmp.log")
#print "Sending Email"

if len(allpoints) > 1:
	send_mail("robot@lijit.com", ["devel@lijit.com"], "Oops.lijit.com AJS Heatmap", "Latest Outage Operations Process Heat Map for yesterday",[outputfile])
os.remove(outputfile)
