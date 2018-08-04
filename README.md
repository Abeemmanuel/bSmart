# bSmart
Smart Diabetes Management
## Inspiration
Two years ago my 4 year old daughter was diagnosed with **Type 1 Diabetes** and since then my main goal in life has been to manage her blood sugar (BG) levels within an acceptable range. Although there are quite a few technologies out there that are of great help in the management of Type 1 Diabetes, I believe there is a lot more we can do to make the lives of Type 1 Diabetics and their care givers easier. I work in data analytics in my day job and thought latest technologies like Internet-of-Things (IoT), Artificial Intelligence (AI), Machine Learning/Deep Learning can be of great help in the management of Type 1 Diabetes. In the quest for **better management** of my daughter's BG numbers I decided to embark on this project to build a system that will capture all the information it can, in real-time, and analyze it and suggest treatment options in an easy to consume format i.e. **text messages on phone**. This system, in its fully developed form, could act like an **AI brain** which can suggest treatment plans in real-time to care givers/baby sitters.

Type 1 Diabetes is an auto-immune disease in which the pancreas stops producing insulin which is an important hormone for converting food into energy. There are 1.5 Million Americans living with Type 1 diabetes and it costs more than $15 Billion each year to manage this disease. Diabetes is the [**most expensive**](http://www.diabetes.org/newsroom/press-releases/2018/economic-cost-study-call-to-congress-2018.html) chronic disease in America today. Improving the care for Type 1 diabetics is not only good for the patients themselves but also for the whole society in terms of lowering healthcare costs.

Typically a Type 1 Diabetic's BG goes up when they eat food and their BG comes down when they inject insulin via an insulin pump or insulin shot. The BG could go too high if not enough insulin is taken and the BG could go dangerously low if too much insulin is taken. Currently healthcare providers suggest insulin dose based on a formula which takes into account the number of carbs in the food eaten. But a true calculation of the insulin dose should also take into account other factors such as the type of food and the activity level to name a few. Making sure the BG level stays within range is a **daily battle** and any assistance with this would be of great help.


## What it does
The system I developed tries to integrate data from two devices namely an **insulin pump** and a **continuous glucose monitor (CGM)** every 5 minutes and uses the insulin intake and BG data to **predict what the BG levels will be in the next 2 hours**. If the predicted BG is too high then an SMS text message is sent to the care giver suggesting an insulin dose and if the predicted BG is too low then a text message is sent suggesting low treatment to the care giver. This system could be expanded to integrate other information like activity, heart rate and ambient temperature all of which have an impact on the BG levels.

## How I built it
Data from the insulin pump and CGM is read using a third party android app which stores the data in a mongoDB. I wrote a python script to read the mongoDB every 2 mins and extract the data and send it to the Azure IoT Hub. An Azure function listens to the Azure IoT Event Hub and stores the data in an Azure SQL Database. Every 10 mins another Azure function reads all the data in the Azure SQL server and executes a stored procedure to create the BG forecast. If the predicted BG is too high or low the Azure function triggers another Azure Function which in turn sends a text message via Twilio service. Bulk of my time was spent in building the prediction engine which is currently rules based but could be expanded to leverage machine learning.


## Testing Instructions
1. Setup the Azure IoT Hub, Azure Storage Account and Storage Queue, Azure Function App using the ARM Templates
2. Create an IOT device in Azure IoT Hub 
3. Setup the Azure functions in the Function App using the bSmartBrainApp Function Scripts
4. Make the function bSmartIoTHubDataCapture trigger on an event from the Azure IoT hub you just created
5. Setup a Twilio account and buy a phone number and register a designated phone number to get the text messages.
6. Change the bSmartSendAlerts Function to have the Twilio secret key
7. Change the bSmartAnalyzeData function trigger every 10 mins and also set the target phone number to the number you registered in Twilio
8. Change the python script to have the device key to the Azure IoT hub.
9. Create the database with ARM template and the DB objects using the database script.
10. Change the Function App DB connection to point to the SQL server created in the above steps
11. Place the python script and the bsmart_test_data_4.csv in the same directory and run the python script. 
PS. I more easier deployment script will be posted soon which won't require all these manual steps.
