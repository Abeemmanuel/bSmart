# bSmart
Smart Diabetes Management
## Inspiration
Two years ago my 4 year old daughter was diagnosed with **Type 1 Diabetes** and since then my main goal in life has been to manage her blood sugar (BG) levels within an acceptable range. Although there are quite a few technologies out there that are of great help in the management of Type 1 Diabetes, I believe there is a lot more we can do to make the lives of Type 1 Diabetics and their care givers easier. I work in data analytics in my day job and thought latest technologies like Internet-of-Things (IoT), Artificial Intelligence (AI), Machine Learning/Deep Learning can be of great help in the management of Type 1 Diabetes. In the quest for **better management** of my daughter's BG numbers I decided to embark on this project to build a system that will capture all the information it can, in real-time, and analyze it and suggest treatment options in an easy to consume format i.e. **text messages on phone**. This system, in its fully developed form, could act like an **AI brain** which can suggest treatment plans in real-time to care givers/baby sitters.

Type 1 Diabetes is an auto-immune disease in which the pancreas stops producing insulin which is an important hormone for converting food into energy. There are 1.5 Million Americans living with Type 1 diabetes and it costs more than $15 Billion each year to manage this disease. Diabetes is the [**most expensive**](http://www.diabetes.org/newsroom/press-releases/2018/economic-cost-study-call-to-congress-2018.html) chronic disease in America today. Improving the care for Type 1 diabetics is not only good for the patients themselves but also for the whole society in terms of lowering healthcare costs.

Typically a Type 1 Diabetic's BG goes up when they eat food and their BG comes down when they inject insulin via an insulin pump or insulin shot. The BG could go too high if not enough insulin is taken and the BG could go dangerously low if too much insulin is taken. Currently healthcare providers suggest insulin dose based on a formula which takes into account the number of carbs in the food eaten. But a true calculation of the insulin dose should also take into account other factors such as the type of food and the activity level to name a few. Making sure the BG level stays within range is a **daily battle** and any assistance with this would be of great help.


## What it does
The system I developed tries to integrate data from two devices namely an **insulin pump** and a **continuous glucose monitor (CGM)** every 5 minutes and uses the insulin intake and BG data to **predict what the BG levels will be in the next 2 hours**. If the predicted BG is too high then an SMS text message is sent to the care giver suggesting an insulin dose and if the predicted BG is too low then a text message is sent suggesting low treatment to the care giver. This system could be expanded to integrate other information like activity, heart rate and ambient temperature all of which have an impact on the BG levels.

## How I built it
Data from the medtronic insulin pump and CGM is read using a third party android app which stores the data in a mongoDB. I wrote a python script to read the mongoDB every 2 mins and extract the data and send it to the Azure IoT Hub. An Azure function listens to the Azure IoT Event Hub and stores the data in an Azure SQL Database. Every 10 mins another Azure function reads all the data in the Azure SQL server and executes a stored procedure to create the BG forecast. If the predicted BG is too high or low the Azure function triggers another Azure Function which in turn sends a text message via Twilio service. Bulk of my time was spent in building the prediction engine which is currently rules based but could be expanded to leverage machine learning.

## Challenges I ran into
* Initially I wanted to develop the python script to run on a raspberry pi and connect to the insulin pump directly but realized it was too much of a technical challenge to deal with. Hence I resorted to using a third party app and also used my laptop instead of the raspberry pi to run the python script.
* The prediction engine needed to be tuned to my daughter's numbers to enable it to make sensible predictions. To make the system more universally usable we need to replace the current rules based engine to a Machine Learning driven algorithm.
* The text messages were initially schedule to run every 5 minutes which ended up annoying my wife who was one of the recipients of the messages, hence I had to reduce it to every 10 minutes.

## Accomplishments that I'm proud of
This is the first time I have been able to analyze my daughter's numbers in real-time and take corrective action based on the numbers. Lot of people rely on rules or gut feeling while managing their kids Type 1 Diabetes. I believe this system has the potential of making lives easy and protect kids with Type 1 diabetes from the harmful effects of sustained out-of-range BG levels. Since this system relies on text messaging to communicate the treatment plan it can help non-technical care givers.

## What I learned
Predicting accurately is a herculean task. It requires a trial and error approach to get the algorithm right. Always err on the side of safety when predictions are related to healthcare. 
It's a fine balance between sending alerts when most needed and avoiding annoying the person we need to alert. Again trial and error approach helps to get the optimal level of alerting. 

## What's next for bSmart Smart Diabetes Management System
1. Create an app to read the data from insulin pump and fitness monitor and send it directly to Azure IoT hub
2. Change the prediction engine to use Machine learning to make it more universally usable by people of all ages.
3. Launch a Beta version for potential customers to start using it.
