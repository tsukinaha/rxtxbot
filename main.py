import subprocess
import schedule
import time
import datetime

chat_id = input("Enter chat_id: ")
token = input("Enter token: ")
# Install vnstat
subprocess.run(['sudo', 'apt', 'install', 'vnstat'])

# Define log file name
log_file = datetime.datetime.now().strftime("%Y-%m-%d.log")

# Define function to run hour script
def run_hour_script():
    subprocess.run(['./hour.sh', chat_id, token], stdout=open(log_file, 'a'), stderr=subprocess.STDOUT)

# Define function to run day script
def run_day_script():
    subprocess.run(['./day.sh', chat_id, token], stdout=open(log_file, 'a'), stderr=subprocess.STDOUT)

# Schedule the hour script to run every hour at minute 0
schedule.every().hour.at(":00").do(run_hour_script)

# Schedule the day script to run every day at 00:01
schedule.every().day.at("00:01").do(run_day_script)

# Run the scheduled tasks
while True:
    schedule.run_pending()
    time.sleep(1)
