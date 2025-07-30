# Yet-Another-Github-Filler
## Background
I am no different from others when i want a greener Github contribution graph so i made this quick script to do this for me.

The script is made to be run on a cron job on Linux but could easily be adapted to run on a Github action or other automated script. But if that's what you want you should probably just use some other filler available. 

What makes this script **special** is that is incorporates the Github cli to add actions such as pull requests, issues, etc for a **better** diamond. As Github cli time stamps cant be edited the need for the script to run often is wanted - thus cron-job. This works out rather well as a "cli" day will always be the most green which is not something wanted on everyday.

By default not everyday will be maxed out and is used to mimic **regular** activity. 

## Setup
1. Change the top variables to what suits you.
2. Run the script with a date format that fits you desired time span e.g. `./git_fill.sh $(date -d "1 year ago" +%Y-%m-%d)`
3. Run `./git_fill.sh` when you want to commit back up to present day or set up a [Cron-job](##cron-job) 

## Cron-job
The cron-job is set to run every half an hour to ensure it runs when your computer is running. The timing can be adjusted but note that the script will only commit if it hasn't run that day.
1. Copy the response of `echo "*/30 * * * * $(pwd)/git_fill.sh"`
2. Paste it inside `crontab -e`
