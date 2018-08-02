
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
INSULIN_MSG = "{\"date_id\": \"%s\",\"date\": \"%s\",\"mins\": \"%s\",\"event\": \"%s\",\"reservoir\": \"%.2f\",\"insulin\": \"%.3f\",\"iob\": \"%.3f\"}"

def send_confirmation_callback(message, result, user_context):
    print("IoT Hub responded to message with status: %s" % (result))


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
        print("Unexpected error %s from IoTHub" % iothub_error)
        return
    except KeyboardInterrupt:
        print ( "IoTHubClient stopped" )

def iothub_client_insulin_run(dateid, datestring, datemins, reserv, ins, iob):

    try:

        print("Preparing nightscout entries for IoT Hub")
        # Build the message with the telemetry data.

        msg_txt_formatted = INSULIN_MSG % (dateid, datestring, datemins, 'INSULIN', reserv, ins, iob)
        message = IoTHubMessage(msg_txt_formatted)

        # Send the message.
        print("Sending message: %s" % message.get_string())
        client.send_event_async(message, send_confirmation_callback, None)
        time.sleep(1)

    except IoTHubError as iothub_error:
        print("Unexpected error %s from IoTHub" % iothub_error)
        return
    except KeyboardInterrupt:
        print("IoTHubClient stopped")

if __name__ == '__main__':
    print("IoT Hub Nightscout Streamer")

    try:

        now = datetime.datetime.now()
        midnight = datetime.datetime.combine(now.date(), datetime.time())
        secs = time.mktime(midnight.timetuple()) * 1000

        # Un-comment the below line to test a High BG event
        ddf = pd.read_csv('bsmart_test_data_4.csv')

        # Un-comment the below line to test a Low BG event
        # ddf = pd.read_csv('bsmart_test_data_5.csv')



        client = iothub_client_init()
        if not ddf.empty:
            for index, row in ddf.iterrows():

                # Simulate sending of insulin data from pump
                # print(secs, int(row.mins), row.reservoir, row.iob)
                iothub_client_insulin_run(int(secs), now, int(row.mins), row.reservoir, row.dose, row.iob)

                # Simulate sending of blood glucose data after 1.1 sec from CGM
                # print(row.dateid1, int(row.mins), row.sgv)
                iothub_client_bg_run(int(secs+1100), now, int(row.mins), int(row.bg))

                # Increment the time by 5 mins
                secs = secs + 300200

    except Exception as e:
        # doesn't exist
            print(e)
