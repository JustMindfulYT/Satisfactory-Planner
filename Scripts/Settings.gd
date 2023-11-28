extends Control

func _on_CloseButton_button_up():
	save_settings()
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Main.tscn")

func save_settings():
	printerr("'save_settings' is not implemented yet!")

func _ready():
	set_audio_settings()

func set_audio_settings():
	$SettingsContainer/SettingsBox/AudioMasterVolume/Input.value = AudioServer.get_bus_volume_db(0)
	$SettingsContainer/SettingsBox/AudioMasterVolume/Input.editable = !AudioServer.is_bus_mute(0)
	$SettingsContainer/SettingsBox/AudioMasterVolume/Mute.pressed = AudioServer.is_bus_mute(0)
	
	$SettingsContainer/SettingsBox/AudioUiVolume/Input.value = AudioServer.get_bus_volume_db(1)
	$SettingsContainer/SettingsBox/AudioUiVolume/Input.editable = !AudioServer.is_bus_mute(1)
	$SettingsContainer/SettingsBox/AudioUiVolume/Mute.pressed = AudioServer.is_bus_mute(1)
	
	$SettingsContainer/SettingsBox/AudioMusicVolume/Input.value = AudioServer.get_bus_volume_db(2)
	$SettingsContainer/SettingsBox/AudioMusicVolume/Input.editable = !AudioServer.is_bus_mute(2)
	$SettingsContainer/SettingsBox/AudioMusicVolume/Mute.pressed = AudioServer.is_bus_mute(2)

func _on_Audio_Master_Volume_Input_drag_ended(value_changed : bool):
	if value_changed == true:
		AudioServer.set_bus_volume_db(0, $SettingsContainer/SettingsBox/AudioMasterVolume/Input.value)

func _on_Audio_Master_Mute_toggled(button_pressed : bool):
	$SettingsContainer/SettingsBox/AudioMasterVolume/Input.editable = !button_pressed
	AudioServer.set_bus_mute(0, button_pressed)

func _on_Audio_UI_Volume_Input_drag_ended(value_changed : bool):
	if value_changed == true:
		AudioServer.set_bus_volume_db(1, $SettingsContainer/SettingsBox/AudioUiVolume/Input.value)

func _on_Audio_UI_Mute_toggled(button_pressed : bool):
	$SettingsContainer/SettingsBox/AudioUiVolume/Input.editable = !button_pressed
	AudioServer.set_bus_mute(1, button_pressed)

func _on_Audio_Music_Volume_Input_drag_ended(value_changed : bool):
	if value_changed == true:
		AudioServer.set_bus_volume_db(2, $SettingsContainer/SettingsBox/AudioMusicVolume/Input.value)

func _on_Audio_Music_Mute_toggled(button_pressed : bool):
	$SettingsContainer/SettingsBox/AudioMusicVolume/Input.editable = !button_pressed
	AudioServer.set_bus_mute(2, button_pressed)
