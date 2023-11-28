extends Node

var current_settings : Dictionary = {}

var current_errors : Array = []

const default_volume = -20.4
const default_settings : Dictionary = {
	"name" : "Settings",
	"settings": {
		"audio": {
			"master": {
				"volume": default_volume,
				"muted": false
			},
			"ui": {
				"volume": default_volume,
				"muted": false
			},
			"music": {
				"volume": default_volume,
				"muted": true
			}
		},
		"experimental": {
			"mod_support": false
		}
	}
}

func _ready():
	print("'Global' initialized")
	var a = loadJson("user://settings.json")
	print(a)
	self.current_settings = a[0]
	check_settings(a[1])

func warning(w : String):
	push_warning(w)

func error(e : String):
	push_error(e)
	printerr(e)

func check_key_dict(dict : Dictionary, default_dict : Dictionary, key : String):
	if dict.has(key) and dict[key] is Dictionary:
		return null
	else:
		var name = dict.name if dict.has("name") else ""
		var w = "Warning - %s Key '%s' is not existing or not a Dictionary" % [name, key]
		var s = "Solution - Using default value"
		var v = default_dict[key] if default_dict.has(key) else null
		return [[w, s], v]

func check_key_float(dict : Dictionary, default_dict : Dictionary, key : String):
	if dict.has(key) and dict[key] is float:
		return null
	else:
		var name = dict.name if dict.has("name") else ""
		var w = "Warning - %s Key '%s' is not existing or not a Floating Point Number" % [name, key]
		var s = "Solution - Using default value"
		var v = default_dict[key] if default_dict.has(key) else null
		return [[w, s], v]

func check_key_bool(dict : Dictionary, default_dict : Dictionary, key : String):
	if dict.has(key) and dict[key] is bool:
		return null
	else:
		var name = dict.name if dict.has("name") else ""
		var w = "Warning - %s Key '%s' is not existing or not a Boolean" % [name, key]
		var s = "Solution - Using default value"
		var v = default_dict[key] if default_dict.has(key) else null
		return [[w, s], v]

func check_value_handler(return_value, key : String):
	if return_value is Array:
		self.current_errors.append(return_value[0])
		self.current_settings[key] = return_value[1]
	return null

func check_settings(exists : bool):
	print("check_settings - start")
	if exists == false or self.current_settings == {}:
		self.current_settings = self.default_settings
		self.saveJson("user://settings.json", self.default_settings)
	var r = null
	var s = self.current_settings
	var d = self.default_settings
	
	r = check_key_dict(s, d, "settings")
	check_value_handler(r, "settings")
	
	printerr("'check_settings' hasnt been fully implemented yet")
	
	print("check_settings - end")

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
		if path.ends_with(".json"):
			f.open(path, File.READ)
			var raw = f.get_as_text()
			print(raw)
			var j = JSON.parse(raw)
			print(j.error)
			var data : Dictionary = {}
			if j.error == OK:
				data = j.result
			print("Successfully read file at path '%s'" % path)
			return [data, true]
		else:
			printerr("File at path '%s' is not a .json file!" % path)
			return [{}, false]
	else:
		printerr("File at path '%s' does not exist!" % path)
		return [{}, false]
