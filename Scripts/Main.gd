extends Control


onready var PanelAnimation = $PanelContainer/PanelAnimation
var sidebarExtended = false

func _on_SidebarToggleButton_button_up():
	if sidebarExtended == false:
		PanelAnimation.play("SidebarExtend")
		sidebarExtended = true
	elif sidebarExtended == true:
		PanelAnimation.play_backwards("SidebarExtend")
		sidebarExtended = false
