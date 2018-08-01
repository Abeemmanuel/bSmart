#r "System.Data"
#r "System.Configuration"
using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public static async Task Run(string myIoTHubMessage, TraceWriter log)
{
    log.Info($"C# IoT Hub trigger function processed a message: {myIoTHubMessage}");
 
       try{
        var str = ConfigurationManager.ConnectionStrings["smartdb"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(str))
        {
            conn.Open();
            var text = "dbo.INSERT_EVENT_DATA";
            
            
            using (SqlCommand cmd = new SqlCommand(text, conn))
            {
                // Set the command to execute stored proc
                cmd.CommandType = CommandType.StoredProcedure;
                
                // Set the parameters                         
                cmd.Parameters.AddWithValue("@EventDoc",myIoTHubMessage);
                cmd.Parameters.Add("@procReturn", SqlDbType.VarChar,500).Direction = ParameterDirection.Output;    
                // Execute the command and log the # rows affected.
                await cmd.ExecuteNonQueryAsync();
                string procReturn = cmd.Parameters["@procReturn"].Value.ToString();

                if(procReturn!="SUCCESS")
                throw new System.ArgumentException(procReturn); 
            }  
        }    
   } 
   catch (Exception e)
        {
            
            log.Info("Exception caught :"+e.Message.ToString());
            throw new System.ArgumentException("Could not write to database"); 
        }
    

}