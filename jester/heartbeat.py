#!/usr/bin/python
import os
import urllib
import httplib2
import logging
from xml.dom import minidom

hostname = os.environ['HOSTNAME']
stack = os.environ['STACK']
baseurl = 'https://'+stack+':8089'
userName = os.environ['SPK_USER']
password = os.environ['SPK_PASS']
interval = os.environ['INTERVAL']
searchWait = os.environ['SEARCHWAIT']

#baseurl = 'https://localhost:8089'
#userName = 'admin'
#password = 'password'
#interval = 300
#searchWait = 60

myRunningDir= '/opt/splunkforwarder/var/log/splunk'
searchQuery = '| inputcsv foo.csv | where sourcetype=access_common | head 5'
searchQuery = searchQuery.strip()

logging.info("Heartbeat routine coming online.")
logging.info("Hostname:"+hostname)
logging.info("Stack:"+stack)
logging.info("URL:"+baseurl)
logging.info("Splunk User"+password)
logging.info("Interval:"+str(interval))
logging.info("Search Wait:"+str(searchWait))

def findMarker:
	try:
		m=open(myRunningDir+'/lastHeartbeat.dat','r')
		marker=int(m.read())
		m.close()
	except:
		logging.warn("Did not find a dat file, assuming this is the very first time...")
		marker=int(time.time())
	return marker

def updateMarker(marker):
	m=open(myRunningDir+'/lastHeartbeat.dat','w')
	m.write(str(marker))
	m.close()

def genHeartbeat():
	try:
		logging.debug("Writing to heartbeat log")
		epoch_time = str(int(time.time()))
		h=open(myRunningDir+'/heartbeat.log','a')
		h.write(epoch_time+":Splunk>Cloud Heartbeat"))
		h.close()
		logging.debug("Writing to heartbeat log done")
	except:
		logging.error("Failed to write to heartbeat log")
		passResults("FAIL","Failed to write to heartbeat log",-1,-1)

def passResults(severity,message,delay,indexdelay):
	try:
		logging.debug("Writing to results log")
		epoch_time = str(int(time.time()))	
		r=open(myRunningDir+'/heartbeat_results.log','a')
		r.write(epoch_time+":"+severity+":"+message+":"+str(delay)+":"+str(indexdelay))
		r.close()
		logging.debug("Writing to results log done")
	except:
		logging.error("Unable to write to results log")

def seekBeat():
	serverContent = httplib2.Http(disable_ssl_certificate_validation=True).request(baseurl + '/services/auth/login', 'POST', headers={}, body=urllib.urlencode({'username':userName, 'password':password}))[1]
	sessionKey = minidom.parseString(serverContent).getElementsByTagName('sessionKey')[0].childNodes[0].nodeValue
	print httplib2.Http(disable_ssl_certificate_validation=True).request(baseurl + '/services/search/jobs/export','POST', headers={'Authorization': 'Splunk %s' % sessionKey},body=urllib.urlencode({'search': searchQuery}))[1]

#Generate a heartbeat message
genHeartbeat()
#Find most recent prior heartbeat
lastSeen=findMarker()
#Run search for all heartbeats since last good one
newLastSeen = seekHeartbeat(lastSeen)
updateMarker(newLastSeen)
