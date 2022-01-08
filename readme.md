Collection of scripts I use for home automation stuff


# Trigger a home assistant scene on unlock (Windows)
When I log in to my laptop, run WindowsLogin script and trigger a scene on my [home assistant](https://www.home-assistant.io/).
Note 1: Set up with Windows Task schedular to only run the script when connected on the home wifi.
Note 2: A check in in the `WindowsLogin` script is added to only run the action when also connected to a second monitor (to prevent my office from lighting up when I am sitting at the couch or kitchen table 😄).

Setup:
1. local-test.ps1: Run this script to test/debug the script locally.
1. trigger-homeassistant.ps1: Run this script to trigger events on home-assistant.
1. WindowsLogin.ps1: This script runs when every I logon to my Windows machine (thanks to some Windows Task scheduling as explained [here](https://www.howtogeek.com/141894/how-to-use-powershell-to-detect-logins-and-alert-through-email/)).
1. utils.ps1: Some useful functions to log both to a file and to the host for example.