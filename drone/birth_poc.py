#!/usr/bin/python
import os
import json
import requests
webhook_url = 'https://hooks.slack.com/services/'+os.environ['SLACKHOOK']

def slackPost(slackMessage):
        slack_data = {
                'text': slackMessage,
                'pretext': "Incoming P0k from a Splunk Docker Hive",
                'username':os.environ['HOSTNAME']
                }
        response = requests.post(
            webhook_url, data=json.dumps(slack_data),
            headers={'Content-Type': 'application/json'}
        )
        if response.status_code != 200:
            raise ValueError(
                'Request to slack returned an error %s, the response is:\n%s'
                % (response.status_code, response.text)
            )
Msg="Fresh born member of the hive\n"
Msg+="Hostname: "+os.environ['HOSTNAME']+"\n"
Msg+="Ip Addr : "+os.environ['IP']+"\n"
try:
        Msg+="My Role : Drone\nMy Queen: "+os.environ['SIRE']+"\n"
except:
        Msg+="My Role : Queen\n"
        Msg+="My Hive : "+os.environ['HIVE']+"\n"
slackPost(Msg)
