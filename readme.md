This repo contains a collection of scripts I use for home automation stuff


# Trigger a home assistant scene on unlock (Windows)
When I log in to my laptop, run `WindowsLogin.ps1` script and trigger a scene on my [home assistant](https://www.home-assistant.io/).
Note 1: Set up with Windows Task schedular to only run the script when connected on the home WIFI.
Note 2: A check in in the `WindowsLogin` script is added to only run the action when also connected to a second monitor (to prevent my office from lighting up when I am sitting at the couch or kitchen table 😄).

Scripts:
1. local-test.ps1: Run this script to test/debug the script locally.
1. trigger-homeassistant.ps1: Run this script to trigger events on home-assistant.
1. WindowsLogin.ps1: This script runs when every I logon to my Windows machine (thanks to some Windows Task scheduling as explained [here](https://www.howtogeek.com/141894/how-to-use-powershell-to-detect-logins-and-alert-through-email/)).
1. utils.ps1: Some useful functions to log both to a file and to the host for example.

Setup:
I have defined some home assistant scenes that I use during the day when I am working at [my home office](https://devopsjournal.io/blog/2021/05/13/home-setup).  

![screen shot of 3 scenes in home assistant: Office Lights, Camera On, Office Leave](/homeassistant.png)  

## Scene 1: Office Lights (this one is automated with the scripts in this repo)
When this one is triggered, my office lights (small desk lamp), my 'Do Epic Shit' signal and my speakers will turn on: everything I need to start working (laptop and monitor have their own flow and can be considered as 'Always on'). I've set this up as with [Shelly Plug S](https://shelly.cloud/products/shelly-plug-s-smart-home-automation-device/) and an extension cord that powers all three devices. Wrapped it in a scene in Home Assistant together with my [Elgato Light Strip](https://www.elgato.com/en/light-strip) for easy switching it on and off. 

## Scene 2: Camera On (to be automated)
When the camera is on (I have two different ones to use), I switch on this scene to turn on the 2 [Elgato Key Light Airs](https://www.elgato.com/en/key-light-air) that I have, so that people can actually see me (check my blogpost on my setup [here](https://devopsjournal.io/blog/2021/05/13/home-setup)). When I am done with the call, I switch off the scene and the lights turn off.

## Scene 3: Office Leave
When I stop working, everything I have automated needs to turn off again, so this scene switches of the desk lamp, the Light strip, the 'Do epic shit' signal, the speakers and the Key Lights.

# Detecting camera is being used (Windows)
In the script `camera-check.ps1` I have a couple of methods to check if you are using the camera. Any process should be picked up, as long as you run the script with admin rights (elevated). This is needed because a lot of applications (like the camera app, slack, usage in a browser) don't take control of the camera directly, but through svchost.exe.

## Test-Loop
Call `Test-Loop` to continually check if the camera is being used, without stopping at the first 'in use' result. This can help you figure out if the script sees all camera's and all uses.

## LoopWithAction
Call `LoopWithAction` to check if the camera is being used, and if so, run the action. This method will stop checking after the first 'in use' result and run the action. It will then wait for the remaining of a minute before checking again (to prevent checking to often).

For the action, update the method 'Run-Action' to your liking. I have a check in there to only send in an update to Home Assistant if needed, but you can do whatever you want here

## CheckCameraOnceWithAction
In the method `CheckCameraOnceWithAction` I have a loop that checks if the camera is being used, and if so, run the action. This method will only run once, and then stop. This setup is used on my machine, where I have setup a task in the Windows Task scheduler to run this script every minute.

# Tested succesfully in action with:
- Teams
- Zoom
- OBS Studio
- Bandicam
- Camtasia recorder
- Slack
