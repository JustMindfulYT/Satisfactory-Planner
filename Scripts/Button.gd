extends Button

# Button Item
onready var button = $"."

# Hover Sound Player
onready var mouseHoverPlayer = $MouseHoverPlayer

# Mouse Release Player
onready var mouseReleasePlayer = $MouseReleasePlayer

# Mouse Click Player
onready var mouseClickPlayer = $MouseClickPlayer

# Connecting the Button signals to the Button
func _ready():
	button.connect("mouse_entered", self, "mouseHover")
	button.connect("mouse_exited", self, "mouseRelease")
	button.connect("button_down", self, "mouseClick")

# Plays the Hover sound
func mouseHover():
	mouseHoverPlayer.play()

# Plays the Release sound
func mouseRelease():
	mouseReleasePlayer.play()

# Plays the Click sound
func mouseClick():
	mouseClickPlayer.play()
