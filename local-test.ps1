# pull in different scripts
. ./trigger-homeassistant.ps1

# setup params
$homeAssistant="http://192.168.1.39:8123"

# call script

$entityId="switch.shelly_plug_s_9a57b1_relay_0"
switchToggle -entityId $entityId -homeAssistant $homeAssistant -command "toggle"

# $entityId = "scene.nieuwe_scene"
# switchScene -entityId $entityId -homeAssistant $homeAssistant -command "turn_on"