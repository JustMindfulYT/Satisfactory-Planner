extends Button

onready var button = $"."

onready var mouseHoverPlayer = $MouseHoverPlayer
onready var mouseReleasePlayer = $MouseReleasePlayer
onready var mouseClickPlayer = $MouseClickPlayer

func _ready():
	button.connect("mouse_entered", self, "mouseHover")
	button.connect("mouse_exited", self, "mouseRelease")
	button.connect("button_down", self, "mouseClick")

func mouseHover():
	mouseHoverPlayer.play()

func mouseRelease():
	mouseReleasePlayer.play()

func mouseClick():
	mouseClickPlayer.play()
