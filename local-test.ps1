# pull in different scripts
. ./trigger-homeassistant.ps1


# call script

$entityId="switch.shelly_plug_s_9a57b1_relay_0"
switchToggle -entityId $entityId -command "toggle"

# $entityId = "scene.officelights"
# switchScene -entityId $entityId -command "turn_on"