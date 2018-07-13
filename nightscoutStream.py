
# app name: bSmart Nightscout data streamer
# script name:nightscoutStream.py
# author: Abraham Pabbathi
# creation date: 06/29/2018
# change date:6/29/2018
#
import pandas as pd
from pymongo import MongoClient
from pandas.io.json import json_normalize
import datetime, time
from iothub_client import IoTHubClient, IoTHubClientError, IoTHubTransportProvider, IoTHubClientResult
from iothub_client import IoTHubMessage, IoTHubMessageDispositionResult, IoTHubError, DeviceMethodReturnValue
import json


# Azure IoT hub connection string
CONNECTION_STRING = "HostName=bSmartHub.azure-devices.net;DeviceId=device-01;SharedAccessKey=dOCOkCc7h5e7LBQR2Xl4W0ehxH77SN2GePmrE6KMj4c="

# Using the MQTT protocol.
PROTOCOL = IoTHubTransportProvider.MQTT
MESSAGE_TIMEOUT = 10000

# Define the JSON message to send to IoT Hub.
DATE_ID = '1530162325000'
DATE = '2018-06-28'
MINS = '1420'
EVENT = 'BASAL'
BG = '160'
RESERVOIR = '90'
INSULIN = '0.5'
BG_MSG = "{\"date_id\": \"%s\",\"date\": \"%s\",\"mins\": \"%s\",\"event\": \"%s\",\"bg\": \"%s\"}"
INSULIN_MSG = "{\"date_id\": \"%s\",\"date\": \"%s\",\"mins\": \"%s\",\"event\": \"%s\",\"reservoir\": \"%.2f\",\"insulin\": \"%.3f\"}"

def send_confirmation_callback(message, result, user_context):
    print ( "IoT Hub responded to message with status: %s" % (result) )


def iothub_client_init():
    # Create an IoT Hub client
    client = IoTHubClient(CONNECTION_STRING, PROTOCOL)
    return client


def iothub_client_bg_run(dateid, datestring, datemins, bg):

    try:

        print ( "Preparing nightscout entries for IoT Hub" )
        # Build the message with the telemetry data.

        msg_txt_formatted = BG_MSG % (dateid, datestring, datemins, 'BG', bg)
        message = IoTHubMessage(msg_txt_formatted)

        # Send the message.
        print("Sending message: %s" % message.get_string())
        client.send_event_async(message, send_confirmation_callback, None)
        time.sleep(1)

    except IoTHubError as iothub_error:
        print ( "Unexpected error %s from IoTHub" % iothub_error )
        return
    except KeyboardInterrupt:
        print ( "IoTHubClient stopped" )

def iothub_client_insulin_run(dateid, datestring, datemins, reserv, ins):

    try:

        print ( "Preparing nightscout entries for IoT Hub" )
        # Build the message with the telemetry data.

        msg_txt_formatted = INSULIN_MSG % (dateid, datestring, datemins, 'INSULIN', reserv, ins)
        message = IoTHubMessage(msg_txt_formatted)

        # Send the message.
        print("Sending message: %s" % message.get_string())
        client.send_event_async(message, send_confirmation_callback, None)
        time.sleep(1)

    except IoTHubError as iothub_error:
        print ( "Unexpected error %s from IoTHub" % iothub_error )
        return
    except KeyboardInterrupt:
        print ( "IoTHubClient stopped" )

if __name__ == '__main__':
    print ( "IoT Hub Nightscout Streamer" )
    #print ( "Press Ctrl-C to exit" )

    # Connect to the MongoDB
    uri = "mongodb://pycharm:pycharm01@ds111258.mlab.com:11258/heroku_00q2r3xq"
    client = MongoClient(uri)
    db = MongoClient(uri).get_database()
    docID1 = '0'
    docID2 = '0'
    try:
        with open('variables.txt') as json_file:
            data = json.load(json_file)
            for p in data['documents']:
                docID1 = p['docID1']
                docID2 = p['docID2']
    except Exception as e:
        # doesn't exist
        print(e)
        docID1 = '0'
        docID2 = '0'

    print('docID1: '+str(docID1))
    print('docID2: '+docID2)

    # Connect to entries collection first
    try:
        collection = db['entries']
        max_id = collection.find_one(sort=[("_id", -1)])["_id"]
        now = datetime.datetime.now()
        midnight = datetime.datetime.combine(now.date(), datetime.time())
        secs = time.mktime(midnight.timetuple()) * 1000
        #cursor = collection.find({"date": {"$gt": secs}})
        cursor = collection.find({"date": {"$gt": docID1}})
        edf = pd.DataFrame(list(cursor))
        if not edf.empty:
            fmt = '%a %b %d %H:%M:%S %Y'
            edf['dateString'] = edf['dateString'].str.replace('CDT ', '')
            edf['dateStr'] = edf['dateString'].apply(lambda x: datetime.datetime.strptime(x, fmt).date())
            edf['mins'] = edf['dateString'].apply(
                lambda x: datetime.datetime.strptime(x, fmt).hour * 60 + datetime.datetime.strptime(x, fmt).minute)
            edf.fillna(0, inplace=True)
            client = iothub_client_init()
            for index, row in edf.iterrows():
                #print(row.date, row.dateStr, int(row.mins), row.sgv)
                iothub_client_bg_run(int(row.date), row.dateStr, int(row.mins), int(row.sgv))
                docID1 = row.date
                print('docID: '+str(docID1))
    except Exception as e:
        # doesn't exist
            print(e)

    try:
        # Connect to device status collection next
        collection = db['devicestatus']
        #cursor = collection.find({"created_at": {"$gt": str(datetime.datetime.today()).split()[0]}})
        cursor = collection.find({"created_at": {"$gt": docID2}})

        ddf = json_normalize(cursor)
        if not ddf.empty:
            ddf = ddf.loc[:, ['created_at', 'pump.iob.timestamp', 'pump.reservoir']]
            ddf.columns = ['created_at', 'timestamp', 'reservoir']
            fmt = '%b %d, %Y  %I:%M:%S %p'
            ddf['mins'] = ddf['timestamp'].apply(
                lambda x: datetime.datetime.strptime(x, fmt).hour * 60 + datetime.datetime.strptime(x, fmt).minute)
            ddf['dateStr'] = ddf['timestamp'].apply(lambda x: datetime.datetime.strptime(x, fmt).date())
            ddf['dateid'] = ddf['timestamp'].apply(lambda x: time.mktime(datetime.datetime.strptime(x, fmt).timetuple()) * 1000)
            ddf['dose'] = round(ddf.reservoir.diff(), 3) * -1
            ddf.fillna(0, inplace=True)
            client = iothub_client_init()
            for index, row in ddf.iterrows():
                #print(row.created_at, row.dateid, row.dateStr, int(row.mins), row.reservoir, row.dose)
                iothub_client_insulin_run(int(row.dateid), row.dateStr, int(row.mins), row.reservoir, row.dose)
                docID2 = str(row.created_at)
                print('docID2: ' + docID2)
    except Exception as e:
        print(e)

    data = {}
    data['documents'] = []
    data['documents'].append({
        'docID1': docID1,
        'docID2': docID2
    })

    with open('variables.txt', 'w') as outfile:
        json.dump(data, outfile)
