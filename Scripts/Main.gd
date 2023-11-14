extends Control

onready var mouseHoverPlayer = $MouseHoverPlayer
onready var mouseReleasePlayer = $MouseReleasePlayer
onready var mouseClickPlayer = $MouseClickPlayer


onready var settingsButton = $SettingsButton
onready var creditsButton = $CreditsButton
onready var quitButton = $QuitButton

onready var quitLabel = $QuitLabel
onready var cancelQuitButton = $CancelQuitButton
onready var confirmQuitButton = $ConfirmQuitButton

func _ready():
	settingsButton.connect("mouse_entered", self, "mouseHover")
	settingsButton.connect("mouse_exited", self, "mouseRelease")
	settingsButton.connect("button_down", self, "mouseClick")
	settingsButton.connect("button_up", self, "show_settings")
	
	creditsButton.connect("mouse_entered", self, "mouseHover")
	creditsButton.connect("mouse_exited", self, "mouseRelease")
	creditsButton.connect("button_down", self, "mouseClick")
	creditsButton.connect("button_up", self, "show_credits")
	
	quitButton.connect("mouse_entered", self, "mouseHover")
	quitButton.connect("mouse_exited", self, "mouseRelease")
	quitButton.connect("button_down", self, "mouseClick")
	quitButton.connect("button_up", self, "show_quit")
	
	cancelQuitButton.connect("mouse_entered", self, "mouseHover")
	cancelQuitButton.connect("mouse_exited", self, "mouseRelease")
	cancelQuitButton.connect("button_down", self, "mouseClick")
	cancelQuitButton.connect("button_up", self, "cancel_quit")
	
	confirmQuitButton.connect("mouse_entered", self, "mouseHover")
	confirmQuitButton.connect("mouse_exited", self, "mouseRelease")
	confirmQuitButton.connect("button_down", self, "mouseClick")
	confirmQuitButton.connect("button_up", self, "confirm_quit")
	
	cancel_quit()


func mouseHover():
	mouseHoverPlayer.play()

func mouseRelease():
	mouseReleasePlayer.play()

func mouseClick():
	mouseClickPlayer.play()


func show_credits():
	pass

func show_settings():
	pass

func show_quit():
	creditsButton.hide()
	settingsButton.hide()
	quitButton.hide()
	
	quitLabel.show()
	cancelQuitButton.show()
	confirmQuitButton.show()

func cancel_quit():
	creditsButton.show()
	settingsButton.show()
	quitButton.show()
	
	quitLabel.hide()
	cancelQuitButton.hide()
	confirmQuitButton.hide()

func confirm_quit():
	get_tree().quit()
