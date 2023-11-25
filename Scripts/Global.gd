extends Node

var current_settings : Dictionary = {}

const default_volume = -20.4
const default_settings : Dictionary = {
	"Audio": {
		"Master": {
			"volume": default_volume,
			"muted": false
		},
		"Ui": {
			"volume": default_volume,
			"muted": false
		},
		"Music": {
			"volume": default_volume,
			"muted": true
		}
	}
}

func _ready():
	print("'Global' initialized")
	current_settings = loadJson("user://settings.json")
	check_settings()

func check_settings():
	if self.current_settings == {}:
		self.current_settings = self.default_settings
		return
	for key in self.current_settings.keys:
		if self.default_settings.has(key):
			continue
		else:
			self.current_settings[key] = self.default_settings[key]

func saveJson(path : String, json : Dictionary):
	var f = File.new()
	if f.file_exists(path):
		var d = Directory.new()
		d.remove(path)
	f.open(path, File.WRITE)
	f.store_string(str(json))
	f.close()

func loadJson(path : String):
	var f = File.new()
	if f.file_exists(path):
		f.open(path)
		var raw = f.get_as_text()
		var j = JSON.parse(raw)
		var data : Dictionary = j.result
		return data
	else:
		return {}
