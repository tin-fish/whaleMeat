#!/usr/bin/python
import subprocess
import re
import time
import os
######################
#
#   BUCKETEER
# Super-crude H-B-W-T-R
# roller script
#
stack = os.environ['STACK']
user = os.environ['SPK_USER']
password = os.environ['SPK_PASS']
rollpause = int(os.environ['INTERVAL'])
cyclepause = int(os.environ['CYCLEWAIT'])
print "init bucketeer..."
buckets_rolled=1
while buckets_rolled>0:
	print "Entering another cycle.  Querying for RF tasks."
	print "Running against "+stack+"..."
	process = subprocess.Popen(['curl','-s','-k','-u',user+':'+password,'https://'+stack+':8089/services/cluster/master/fixup?level=replication_factor'],stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
	print "REST responded.  Parsing results..."
	response = process.stdout.read().splitlines()
	bucket="NONE"
	buckets_rolled=0
	for line in response:
		m=re.match(r'\s+<title>(.*)<\/title>',line)
		if m:
			bucket=m.group(1)	
			print "Looking at "+bucket
		elif line=="            <s:key name=\"reason\">Cannot replicate as bucket hasn't rolled yet.</s:key>":
			print ">>>This is a hot bucket waiting to roll!"
			process = subprocess.Popen(['curl','-s','-k','-u',user+':'+password,'https://'+stack+':8089/services/cluster/master/control/control/roll-hot-buckets','-X','POST','-d','bucket_id='+bucket],stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
			buckets_rolled=buckets_rolled+1
			time.sleep(rollpause)
	print "I rolled "+str(buckets_rolled)+" in that iteration"
	if buckets_rolled>0:
		print "Sleeping..."
		time.sleep(cyclepause)
