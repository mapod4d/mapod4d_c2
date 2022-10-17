# tool

# class_name

# extends
extends Node
## Root object of multiverse.
##
## This object support autoload of general scenes and metaverses.
##


# ----- signals

# ----- enums

# ----- constants
const MAPOD4D_MAIN_RES = "res://mapod4d_core/mapod4d_main/mapod4d_main.tscn"
const MAPOD4D_START = "res://mapod4d_core/mapod4d_start/mapod4d_start.tscn"

# ----- exported variables

# ----- public variables

# ----- private variables
var _current_loaded_scene = null
var _metaverse_files = []
var _loading_scene = ""

# ----- onready variables
@onready var mapod4d_main = get_node_or_null("/root/Mapod4dMain")
@onready var mapod4d_intro  = true

# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	_on_local_meaverses_list_requested()
	if mapod4d_main == null:
		## support for F6 in edit mode when MopodMain is Null (not main scene)
		## force not show intro
		_start_f6()
	else:
		## support for F5 in run mode MopodMain is main scene
		_mapod4d_start()


# ----- remaining built-in virtual methods

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if _loading_scene != "":
		var progress = []
		var status = ResourceLoader.load_threaded_get_status(
				_loading_scene, progress)
		## progressbar = progress[0] * 100
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			pass ## scene is loaded 
	else:
		_loading_scene = ""
		## progressbar = 0
		set_process(false)


# ----- public methods
func im_alive():
	print("IME")


# ----- private methods

## load Mapod4dMain
func _loadMain():
	var local_current_scene = get_tree().current_scene
	if not (local_current_scene is Mapod4dMain):
		var root = get_node("/root")
		var mapod4d_main_res = load(MAPOD4D_MAIN_RES)
		if mapod4d_main_res != null:
			mapod4d_main = mapod4d_main_res.instantiate()
			root.remove_child(local_current_scene)
			root.add_child(mapod4d_main)
			mapod4d_main.owner = root
	else:
		local_current_scene = null
	return local_current_scene


## load scene no progress bar
func _load_npb_scene(local_current_scene):
	var ret_val = false
	mapod4d_main = get_node_or_null("/root/Mapod4dMain")
	if mapod4d_main != null:
		var loaded_scene_placeholder = mapod4d_main.get_node("LoadedScene")
		if loaded_scene_placeholder.get_child_count() > 0:
			var children = loaded_scene_placeholder.get_children()
			for child in children:
				child.queue_free()
		## add new loaded scene
		loaded_scene_placeholder.add_child(local_current_scene)
		local_current_scene.owner = loaded_scene_placeholder
		## new current scene
		_current_loaded_scene = local_current_scene
		ret_val = true
	return ret_val


## called only on F6
func _start_f6():
	_current_loaded_scene = null
	## workaroung bake problem (godot 3.5.1)
	await get_tree().create_timer(0.5).timeout
	var local_current_scene = _loadMain()
	if local_current_scene != null:
		if _load_npb_scene(local_current_scene) == true:
			pass # error load scene
	else:
		pass # error load main


## called only on start
func _mapod4d_start():
	## workaroung bake problem (godot 3.5.1)
	await get_tree().create_timer(0.5).timeout
	var start_scene_res = load(MAPOD4D_START)
	var start_scene = start_scene_res.instantiate()
	var screen_size = DisplayServer.screen_get_size()
	@warning_ignore(integer_division)
	var x_position = floor(screen_size.x / 2) - floor(1024 / 2)
	@warning_ignore(integer_division)
	var y_position = floor(screen_size.y / 2) - floor(768 / 2)
	if x_position < 0:
		x_position = 0
	if y_position < 0:
		y_position = 0
	start_scene.set_position(Vector2i(x_position, y_position))
	if _load_npb_scene(start_scene) == true:
		_current_loaded_scene.scene_requested.connect(_on_scene_requested)


## load new scene with progress bar and fullscreen flag
func _on_scene_requested(scene_name, fullscreen_flag):
	print("_on_scene_requested " + scene_name + " " + str(fullscreen_flag))
	_current_loaded_scene.visible = false
	if fullscreen_flag == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		## DisplayServer.window_set_size(Vector2i(1920, 1080))
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	## start load scene
	_loading_scene = scene_name
	var result = ResourceLoader.load_threaded_request(_loading_scene)
	if result != OK:
		print("ERRORLOADRESOURCE")
		_loading_scene = null
	else:
		## progressbar = 0
		set_process(true)


## load local metaverses list
func _on_local_meaverses_list_requested():
	var dir = DirAccess.open("user://metaverses")
	if dir != null:
		## dir exists
		var list_files = dir.get_files()
		for file_name in list_files:
			if file_name.ends_with(".json"):
				var file = FileAccess.open(
					"user://metaverses/" + file_name, FileAccess.READ)
				if file != null:
					_json_check(file)
				else:
					print("FILEERROR")
	else:
		print("DIRERROR")


## check json file
func _json_check(file):
	const RVER = "(?<digit0>[0-9]+)\\.(?<digit1>[0-9]+)\\.(?<digit2>[0-9]+)\\.(?<digit3>[0-9]+)"
	var regex = RegEx.new()
	regex.compile(RVER)
	## file exists
	var json = JSON.new()
	if json.parse(file.get_as_text()) == OK:
		## json ok
		print(str(json.data))
		var version = regex.search(json.data.version)
		if version != null:
			## version ok
			var data = {}
			data["metaversefile"] = json.data.filename + \
					"." + json.data.extension
			data["core"] = version.get_string("digit0")
			data["ver"] = version.get_string("digit1")
			data["build"] = version.get_string("digit2")
			data["subbuild"] = version.get_string("digit3")
			var metaverse_file_exists = FileAccess.file_exists(
					"users://metaverse" + "/" + data["metaversefile"])
			if metaverse_file_exists == true:
				print("OK")
				_metaverse_files.push_back(data)
			else:
				print("METAVERSEERROR")
		else:
			print("VERSIONERROR")
	else:
		print("PARSEERROR")

