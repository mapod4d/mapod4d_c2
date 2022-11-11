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
var _loading_scene_res = ""
var _resource_loaded = false


# ----- onready variables
@onready var mapod4d_main = get_node_or_null("/root/Mapod4dMain")
@onready var mapod4d_intro  = true

# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
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
	if _loading_scene_res != "":
		if _resource_loaded == false:
			var progress = []
			var status = ResourceLoader.load_threaded_get_status(
					_loading_scene_res, progress)
			var perc = progress[0] * 100 * 1.0
			_set_progress_bar(perc)
			print("progress " + str(perc))
			if status == ResourceLoader.THREAD_LOAD_LOADED:
				print("loaded") ## scene is loaded
				_resource_loaded == true
				set_process(false)
				call_deferred("_load_scene")
	else:
		_loading_scene_res = ""
		## progressbar = 0
		set_process(false)


# ----- public methods


func im_alive():
	print("IMA")




# ----- private methods

## load Mapod4dMain and return the instance
func _loadMain():
	var local_current_scene = get_tree().current_scene
	if not (local_current_scene is Mapod4dMain):
		var root = get_node("/root")
		var mapod4d_main_res = preload(MAPOD4D_MAIN_RES)
		if mapod4d_main_res != null:
			mapod4d_main = mapod4d_main_res.instantiate()
			root.remove_child(local_current_scene)
			root.add_child(mapod4d_main)
			mapod4d_main.owner = root
	else:
		local_current_scene = null
	return local_current_scene


func _init_progress_bar():
	mapod4d_main = get_node_or_null("/root/Mapod4dMain")
	if mapod4d_main != null:
		mapod4d_main.init_progress_bar()


func _set_progress_bar(value: float):
	mapod4d_main = get_node_or_null("/root/Mapod4dMain")
	if mapod4d_main != null:
		mapod4d_main.set_progress_bar(value)


func _end_progress_bar():
	mapod4d_main = get_node_or_null("/root/Mapod4dMain")
	if mapod4d_main != null:
		mapod4d_main.end_progress_bar()


## load scene without progressbar and update
## _current_loaded_scene updated
func _load_npb_scene(scene):
	var ret_val = false
	mapod4d_main = get_node_or_null("/root/Mapod4dMain")
	if mapod4d_main != null:
		var loaded_scene_placeholder = mapod4d_main.get_node("LoadedScene")
		if loaded_scene_placeholder.get_child_count() > 0:
			var children = loaded_scene_placeholder.get_children()
			for child in children:
				child.queue_free()
		## add new loaded scene
		loaded_scene_placeholder.add_child(scene)
		scene.owner = loaded_scene_placeholder
		## new current scene
		_current_loaded_scene = scene
		ret_val = true
	return ret_val


## load scene with progressbar and update
## _current_loaded_scene updated
func _load_scene():
	var ret_val = false
	print("_load_scene()")
	var scene_res = ResourceLoader.load_threaded_get(_loading_scene_res)
	_loading_scene_res = ""
	if scene_res != null:
		var scene_instance = scene_res.instantiate()
		mapod4d_main = get_node_or_null("/root/Mapod4dMain")
		if mapod4d_main != null:
			var loaded_scene_placeholder = mapod4d_main.get_node("LoadedScene")
			if loaded_scene_placeholder.get_child_count() > 0:
				var children = loaded_scene_placeholder.get_children()
				for child in children:
					child.queue_free()
			## add new loaded scene
			loaded_scene_placeholder.add_child(scene_instance)
			scene_instance.owner = loaded_scene_placeholder
			## new current scene
			_current_loaded_scene = scene_instance
			ret_val = true
	_end_progress_bar()
	return ret_val

## load scene no progress bar and update
## _current_loaded_scene updated
func _attach_current_loaded_scene_signals():
	if _current_loaded_scene is BaseMapod4dUi:
		_current_loaded_scene.scene_requested.connect(
			_on_scene_requested, CONNECT_DEFERRED)
		_current_loaded_scene.scene_npb_requested.connect(
			_on_scene_npb_requested, CONNECT_DEFERRED)


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


## called only on start F5
func _mapod4d_start():
	## workaroung bake problem (godot 3.5.1)
	await get_tree().create_timer(0.5).timeout
	var start_scene_res = preload(MAPOD4D_START)
	var start_scene_instance = start_scene_res.instantiate()
	var screen_size = DisplayServer.screen_get_size()
	@warning_ignore(integer_division)
	var x_position = floor(screen_size.x / 2) - floor(1024 / 2)
	@warning_ignore(integer_division)
	var y_position = floor(screen_size.y / 2) - floor(768 / 2)
	if x_position < 0:
		x_position = 0
	if y_position < 0:
		y_position = 0
	start_scene_instance.set_position(Vector2i(x_position, y_position))
	if _load_npb_scene(start_scene_instance) == true:
		_attach_current_loaded_scene_signals()


## elaborates signal load new scene 
## without thr progressbar and the fullscreen flag
func _on_scene_npb_requested(scene_name, fullscreen_flag):
	print("_on_scene_npd_requested " + scene_name + " " + str(fullscreen_flag))
	_current_loaded_scene.visible = false
	if fullscreen_flag == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	# load scene
	var scene_res = load(scene_name)
	if scene_res != null:
		var scene = scene_res.instantiate()
		if scene != null:
			if _load_npb_scene(scene) == true:
				_attach_current_loaded_scene_signals()


## elaborates signal load new scene 
## with the progressbar and the fullscreen flag
func _on_scene_requested(scene_name, fullscreen_flag):
	print("_on_scene_requested " + scene_name + " " + str(fullscreen_flag))
	_current_loaded_scene.visible = false
	if fullscreen_flag == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	_init_progress_bar()
	## start load scene
	_loading_scene_res = scene_name
	_resource_loaded = false
	var result = ResourceLoader.load_threaded_request(_loading_scene_res)
	if result != OK:
		print("ERRORLOADRESOURCE")
		_loading_scene_res = ""
	else:
		## progressbar = 0
		set_process(true)

