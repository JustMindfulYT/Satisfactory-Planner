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


func check_project_valid(project : Dictionary):
	if not(project.has("info") and project["info"] is Dictionary):
		return [false, "'info' key missing or not a Dictionary"]
	else:
		if not(project.info.has("name") and project.info["name"] is String):
			return [false, "'info/name' key missing or not a String"]
		if not(project.info.has("creator") and project.info["creator"] is String):
			return [false, "'info/creator' key is missing or not a String"]
	if not(project.has("production_lines") and project["production_lines"] is Dictionary):
		return [false, "'production_lines' key is missing or not a Dictionary"]
	else:
		for line in project.production_lines.keys():
			var a = check_production_line(line, project.production_lines[line])
			if a[0]:
				continue
			else:
				return [false, a[1]]
		return [true, ""]

func check_production_line(name : String, line : Dictionary):
	### Name
	if not(line.has("name") and line["name"] is String):
		return [false, "'production_lines/%s/name' is missing or not a Dictionary" % name]
	### Resources
	if not(line.has("resources") and line["resources"] is Dictionary):
		return [false, "'production_lines/%s/resources' is missing or not a Dictionary" % name]
	else:
		for resource in line.resources:
			if not(resource is int):
				return [false, "'production_lines/%s/resources/%s' is not a Number" % [name, resource]]
	### Input
	if not(line.has("input") and line["input"] is Dictionary):
		return [false, "'production_lines/%s/input' is missing or not a Dictionary" % name]
	else:
		for input in line.input:
			if not(input is int):
				return [false, "'production_lines/%s/input/%s' is not a Number" % [name, input]]
	### Output
	if not(line.has("output") and line["output"] is Dictionary):
		return [false, "'production_lines/%s/output' is missing or not a Dictionary" % name]
	else:
		for output in line.output:
			if not(output is int):
				return [false, "'production_lines/%s/output/%s' is not a Number" % [name, output]]
	### Power
	if not(line.has("power") and line["power"] is Dictionary):
		return [false, "'production_lines/%s/power' is missing or not a Dictionary" % name]
	else:
		## Total
		if not(line.power.has("total") and line.power["total"] is int):
			return [false, "'production_lines/%s/power/total' is missing or not a Number" % name]
		## Buildings
		if not(line.power.has("buildings") and line.power["buildings"] is Dictionary):
			return [false, "'production_lines/%s/power/buildings' is missing or not a Dictionary" % name]
		else:
			for building in line.power.buildings.keys():
				var a = check_building_power(name, building, line.power.buildings[building])
				if a[0]:
					continue
				else:
					return [false, a[1]]
	### Items
	if not(line.has("items") and line["items"] is Dictionary):
		return [false, "'production_lines/%s/items' is missing or not a Dictionary" % name]
	else:
		for item in line.items.keys():
			var a = check_item(name, item, line.items[item])
			if a[0]:
				continue
			else:
				return [false, a[1]]
	return [true, ""]

func check_building_cost(name : String, b_name : String, b : Dictionary):
	# Times
	if not(b.has("times") and b["times"] is int):
		return [false, "'production_lines/%s/power/buildings/%s/times' is missing or not a Number" % [name, b_name]]
	# Cost
	if not(b.has("cost") and b["cost"] is Dictionary):
		return [false, "'production_lines/%s/power/buildings/%s/cost' is missing or not a Dictionary" % [name, b_name]]
	else:
		for c in b.cost:
			if not(c is int):
				return [false, "'production_lines/%s/buildings/%s/cost/%s' is not a Number" % [name,b_name ,c]]
	return [true, ""]

func check_building_power(name : String, b_name : String, b : Dictionary):
	# Times
	if not(b.has("times") and b["times"] is int):
		return [false, "'production_lines/%s/power/buildings/%s/times' is missing or not a Number" % [name, b_name]]
	# Consumption
	if not(b.has("consumption") and b["consumption"] is int):
		return [false, "'production_lines/%s/power/buildings/%s/consumption' is missing or not a Number" % [name, b_name]]
	# Recipes
	if not(b.has("recipes") and b["recipes"] is Dictionary):
		return [false, "'production_lines/%s/power/buildings/%s/recipes' is missing or not a Dictionary" % [name, b_name]]
	else:
		for recipe in b.recipes.keys():
			var a = check_recipe(name, b_name, recipe, b.recipes[recipe])
			if a[0]:
				continue
			else:
				return [false, a[1]]
	return [true, ""]

func check_recipe(name : String, b_name : String, r_name : String, r : Dictionary):
	# Times
	if not(r.has("times") and r["times"] is int):
		return [false, "'production_lines/%s/power/buildings/%s/recipes/%s/times' is missing or not a Number" % [name, b_name, r_name]]
	# Consumption
	if not(r.has("consumption") and r["consumption"] is int):
		return [false, "'production_lines/%s/power/buildings/%s/recipes/%s/consumption' is missing or not a Number" % [name, b_name, r_name]]
	return [true, ""]

func check_item(name : String, i_name : String, i : Dictionary):
	# production
	if not(i.has("production") and i["production"] is Dictionary):
		return [false, "'production_lines/%s/items/%s/production' is missing or not a Dictionary" % [name, i_name]]
	else:
		for item in i.production.keys():
			var a = check_item_a(name, i_name, "production", i.production[item])
			if a[0]:
				continue
			else:
				return [false, a[1]]
	if not(i.has("consumption") and i["consumption"] is Dictionary):
		return [false, "'production_lines/%s/items/%s/consumption' is missing or not a Dictionary" % [name, i_name]]
	else:
		for item in i.production.keys():
			var a = check_item_a(name, i_name, "consumption", i.production[item])
			if a[0]:
				continue
			else:
				return [false, a[1]]
	return [true, ""]

func check_item_a(name : String, i_name : String, p : String, i : Dictionary):
	# ips
	if not(i.has("ips") and i["ips"] is int):
		return [false, "'production_lines/%s/items/%s/%s/ips' is missing or not a Number" % [name, i_name, p]]
	# items
	if not(i.has("items") and i["items"] is Dictionary):
		return [false, "'production_lines/%s/items/%s/%s/items' is missing or not a Dictionary" % [name, i_name, p]]
	else:
		for item in i.keys():
			if not(item is int):
				return [false, "'production_lines/%s/items/%s/%s/items/%s' is not a Number" % [name, i_name, p, item]]
	return [true, ""]

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
