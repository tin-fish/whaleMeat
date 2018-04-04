#!/usr/bin/python
import os
import logging
import time
import socket
from splunklib.client import connect
from pprint import pprint
import splunklib.results as results
hostname = os.environ['HOSTNAME']
stack = os.environ['STACK']
baseHost = os.environ['SEARCHHEAD']
baseScheme = os.environ['SH_SCHEME']
restPort = os.environ['SH_PORT']
userName = os.environ['SPK_USER']
password = os.environ['SPK_PASS']
interval = int(os.environ['INTERVAL'])
searchWait = int(os.environ['SEARCHWAIT'])
throttleBeat = int(os.environ['THROTTLEBEAT'])
logLVL=os.environ['LOGLEVEL']
myRunningDir= '/opt/splunkforwarder/var/log/splunk'

logger = logging.getLogger()

logLVL="DEBUG"

if logLVL=="WARN":
	logger.setLevel(logging.WARN)
elif logLVL=="INFO":
	logger.setLevel(logging.INFO)
elif logLVL=="DEBUG":
	logger.setLevel(logging.DEBUG)
else:
	logger.setLevel(logging.INFO)
logging.info("Heartbeat routine coming online.")
logging.info("Hostname:"+hostname)
logging.info("Stack:"+stack)
logging.info("BaseHost:"+baseHost)
logging.info("BaseScheme:"+baseScheme)
logging.info("RESTPort:"+restPort)
logging.info("Splunk User"+userName)
logging.info("Interval:"+str(interval))
logging.info("Search Wait:"+str(searchWait))
logging.info("Throttle Heartbeats:"+str(throttleBeat))
logging.info("Working directory:"+myRunningDir)

def findMarker():
	try:
		m=open(myRunningDir+'/lastHeartbeat.dat','r')
		marker=int(m.read())+1
		m.close()
	except:
		logging.warn("Did not find a dat file, assuming this is the very first time...")
		marker=int(time.time())
	return marker

def updateMarker(marker):
	m=open(myRunningDir+'/lastHeartbeat.dat','w')
	m.write(str(marker))
	m.close()

def genHeartbeat(epoch):
	try:
		logging.debug("Writing to heartbeat log")
		epoch_time = str(epoch)
		h=open(myRunningDir+'/heartbeat.log','a')
		h.write(epoch_time+"~Splunk>Cloud Heartbeat\n")
		h.close()
		logging.debug("Writing to heartbeat log done")
	except:
		logging.error("Failed to write to heartbeat log")
		genError("Step error: Failed write to heartbeat log")

def genError(error):
	try:
		logging.debug("Writing to results log")
		epoch_time=str(int(time.time()))
		h=open(myRunningDir+'/heartbeat_results.log','a')
		h.write(epoch_time+"~"+stack+"~"+error+"\n")
		h.close()
		logging.debug("Writing to results.log")
	except:
		logging.error("Cannot write to log for results!")

logging.info("Entering main loop")
while 1==1:
	logging.debug("Loop start, seeking markers")
	lastRun=findMarker()
	thisRun=int(time.time())
	lastDelta=thisRun-lastRun
	logging.info("Seconds since last run is "+str(lastDelta))
	if lastDelta>throttleBeat:
		logging.warn("Previous run exceeds throttle.  Snipping to "+str(throttleBeat))
		lastRun=thisRun-throttleBeat
	logging.debug("Generating initial heartbeat")
	genHeartbeat(thisRun)
	logging.debug("Sleeping the searchWait ("+str(searchWait)+")")
	time.sleep(searchWait)
	logging.info("Running search element")
	try:
		opts = {}
		opts = {
			'args': ['search index=_internal host="'+hostname+'" earliest='+str(lastRun)+' sourcetype="heartbeat*" | eval indexdelay=_time-_indextime, readdelay=now()-_indextime, timeread=now() | rename _time AS logtime | table logtime, indexdelay, readdelay, timeread '],
			'kwargs': {
				'username': userName,
				'scheme': baseScheme,
 				'host': baseHost,
 				'version': None,
 				'password': password,
				'port': restPort
			}
		}
		search = opts["args"][0]
		service = connect(**opts["kwargs"])
		socket.setdefaulttimeout(None)
		response = service.jobs.oneshot(search)
		reader = results.ResultsReader(response)
		h=open(myRunningDir+'/heartbeat_results.log','a')
		rows=0
		for result in reader:
			logging.debug("Parsing a row >>>>>>>>>>>>>")
			message = result["timeread"]
			message = message+"~"+stack
			message = message+"~Heartbeat Received"
			message = message+"~"+result["logtime"]
			message = message+"~"+result["indexdelay"]
			message = message+"~"+result["readdelay"]
			message = message+"~"+str(interval)
			message = message+"~"+str(searchWait)
			h.write(message+"\n")
			rows=rows+1
		h.close()
		logging.debug("We have received "+str(rows)+" rows.")
		if rows>0:
			logging.debug("Updating marker file")
			updateMarker(thisRun)
		else:
			genError("Step error: Search OK, no heartbeat present")

	except:
		logging.error("Search element failed")
		genError("Step error: Failed to search")
	logging.debug("Finished main body")
	actualSleep=interval-(int(time.time())-thisRun)
	logging.debug("Actual sleep interval is "+str(actualSleep))
	logging.debug("zzz")
	time.sleep(actualSleep)
