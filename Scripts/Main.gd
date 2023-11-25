extends Control


func _ready():
	_on_CancelQuitButton_button_up()

func funcErr(funcName : String):
	push_error("Function '" + funcName + "' not implemented")
	printerr("Function '" + funcName + "' not implemented")

func _on_PlayButton_button_up():
	funcErr("_on_PlayButton_button_up()")


func _on_SettingsButton_button_up():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Settings.tscn")


func _on_CreditsButton_button_up():
	funcErr("_on_CreditsButton_button_up()")


func _on_QuitButton_button_up():
	$PlayButton.hide()
	$CreditsButton.hide()
	$SettingsButton.hide()
	$QuitButton.hide()
	
	$QuitLabel.show()
	$CancelQuitButton.show()
	$ConfirmQuitButton.show()


func _on_CancelQuitButton_button_up():
	$PlayButton.show()
	$CreditsButton.show()
	$SettingsButton.show()
	$QuitButton.show()
	
	$QuitLabel.hide()
	$CancelQuitButton.hide()
	$ConfirmQuitButton.hide()


func _on_ConfirmQuitButton_button_up():
	get_tree().quit()
