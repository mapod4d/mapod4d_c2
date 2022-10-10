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
	pass


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
func _load_np_scene(local_current_scene):
	var ret_val = false
	mapod4d_main = get_node_or_null("/root/Mapod4dMain")
	if mapod4d_main != null:
		var loaded_scene_placeholder = mapod4d_main.get_node("LoadedScene")
		var child_zero = loaded_scene_placeholder.get_child(0)
		if child_zero != null:
			child_zero.queue_free()
		## add new loaded scene
		loaded_scene_placeholder.add_child(local_current_scene)
		local_current_scene.owner = loaded_scene_placeholder
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
		if _load_np_scene(local_current_scene) == true:
			pass # error load scene
	else:
		pass # error load main


## called only on start
func _mapod4d_start():
	## workaroung bake problem (godot 3.5.1)
	await get_tree().create_timer(0.5).timeout
	var start_scene_res = load(MAPOD4D_START)
	var start_scene = start_scene_res.instantiate()
	# tmp, must be load with progressbar
	_load_np_scene(start_scene)
	

