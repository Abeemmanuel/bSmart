#r "Newtonsoft.Json"
#r "Twilio.Api"
#r "System.Data"
#r "System.Configuration"

using System;
using Newtonsoft.Json;
using Twilio;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public static void Run(string alertMessage, out SMSMessage smsmessage,  TraceWriter log)
{
    log.Info($"C# alert triggered function called with input: {alertMessage}");

    // In this example the queue item is a JSON string representing an order that contains the name of a 
    // customer and a mobile number to send text updates to.
    dynamic alert = JsonConvert.DeserializeObject(alertMessage);
    string msg = "Hi " + alert.name +" "+ alert.instructions;
    log.Info(msg);
    // Even if you want to use a hard coded message and number in the binding, you must at least 
    // initialize the SMSMessage variable.
    smsmessage = new SMSMessage();
    smsmessage.Body = msg;
    smsmessage.To = alert.mobileNumber;
    

}
