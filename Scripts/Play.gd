extends Control

var projects : Array = []

var selected_item : int = -1


func _ready():
	load_projects()
	print(projects)
	for project in self.projects:
		$ProjectList.items.append(project.name)

func load_projects():
	var d = Directory.new()
	if not(d.dir_exists("user://projects")):
		d.make_dir("user://projects")
		return
	d.open("user://projects")
	var f_names : Array = []
	d.list_dir_begin()
	var f_name = d.get_next()
	f_names.append(f_name)
	while f_name != "":
		if d.current_is_dir():
			f_name = d.get_next()
			print("found dir : %s" % f_name)
			continue
		else:
			if f_name.ends_with(".json"):
				print("found json : %s" % f_name)
				f_names.append(f_name)
				f_name = d.get_next()
				continue
			else:
				print("found file : %s" % f_name)
				f_name = d.get_next()
				continue
	if f_names.find(".") != -1:
		f_names.remove(f_names.find("."))
	print("file_names : " + str(f_names))
	
	for file in f_names:
		var p : Dictionary = Global.loadJson("user://projects/%s" % file)[0]
		var a : Array = Global.check_project_valid(p)
		if a[0] == false:
			return
		self.projects.append(p)



func _on_AddButton_button_up():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/NewProject.tscn")


func _on_OpenButton_button_up():
	pass


func _on_CancelButton_button_up():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Main.tscn")


func _on_ProjectList_item_selected(index):
	selected_item = index
	$OpenButton.disabled = false


func _on_ProjectList_item_activated(index):
	selected_item = index
	_on_OpenButton_button_up()
