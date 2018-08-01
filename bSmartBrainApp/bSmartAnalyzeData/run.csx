#r "System.Data"
#r "System.Configuration"
#r "Newtonsoft.Json"
using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using Newtonsoft.Json;

public static async Task Run(TimerInfo myTimer,ICollector<string> alertQueueItem, TraceWriter log)
{
    log.Info($"C# Timer trigger function executed at: {DateTime.Now}");
    
    //Set the name and number of the phone number to send sms
    string recipientNumber = "+12222222222";
    string recipientName = "Abe";

    try{
        var str = ConfigurationManager.ConnectionStrings["smartdb"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(str))
        {
            conn.Open();
            var text = "dbo.ANALYZE_EVENT_DATA";
            
            
            using (SqlCommand cmd = new SqlCommand(text, conn))
            {
                // Set the command to execute stored proc
                cmd.CommandType = CommandType.StoredProcedure;
                
                // Set the parameters                         
                cmd.Parameters.Add("@procReturn", SqlDbType.VarChar,500).Direction = ParameterDirection.Output;    
                // Execute the command and log the # rows affected.
                await cmd.ExecuteNonQueryAsync();
                string procReturn = cmd.Parameters["@procReturn"].Value.ToString();

                if(procReturn!="NO ACTION"){

                    log.Info(procReturn);

                    Object alertMessage = new {
                                name=recipientName,
                                instructions="Lucy might need "+procReturn,
                                mobileNumber=recipientNumber
                    };
                    var jsonAlert = JsonConvert.SerializeObject(alertMessage);
                    alertQueueItem.Add(jsonAlert);  
                      
                    log.Info("Sent sms alerts");
                }
                
            }  
        }    
   } 
   catch (Exception e)
        {
            
            log.Info("Exception caught :"+e.Message.ToString());
            throw new System.ArgumentException("Could not write to database"); 
        }
}
