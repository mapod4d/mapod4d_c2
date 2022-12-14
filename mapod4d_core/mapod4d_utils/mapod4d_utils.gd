# tool

# class_name
class_name Mapod4dUtils

# extends
extends Object

## A brief description of your script.
##
## A more detailed description of the script.
##
## @tutorial:			http://the/tutorial1/url.com
## @tutorial(Tutorial2): http://the/tutorial2/url.com


# ----- signals

# ----- enums
enum MAPOD4D_METAVERSE_LOCATION {
	M4D_DEV = 0,
	M4D_LOCAL,
	M4D_NET,
}

# ----- constants
const MAPOD4D_METAVERSE_EXT = "ma4d"
const TEMPL_DIR = "res://mapod4d_templates/"
const TEMPL_METAVERESE = "mapod4d_templ_metaverse.tscn"
const TEMPL_LIST_OF_PLANET = "mapod4d_templ_list_of_planets.tres"

# ----- exported variables

# ----- public variables

# ----- private variables
var _current_location = ""
var _metaverse_list = []
var _metaverse_dir = ""
var _metaverse_scene_path = ""
var _metaverse_data_path = ""
var _metaverse_dir_assets = ""
var _metaverse_dir_tamt = ""
var _metaverse_dir_planets = ""

# ----- onready variables


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# ----- remaining built-in virtual methods

# ----- public methods

func get_multiverse_location(location: MAPOD4D_METAVERSE_LOCATION):
	var ret_val = "res://mapod4d_multiverse_dev"
	match location:
		Mapod4dUtils.MAPOD4D_METAVERSE_LOCATION.M4D_LOCAL:
			ret_val = "res://mapod4d_multiverse_local"
		Mapod4dUtils.MAPOD4D_METAVERSE_LOCATION.M4D_DEV:
			ret_val = "res://mapod4d_multiverse_dev"
		Mapod4dUtils.MAPOD4D_METAVERSE_LOCATION.M4D_NET:
			ret_val = "res://mapod4d_multiverse_net"
	return ret_val


## set default current metaverse path
func set_current_metaverse_paths(metaverse_id):
	_metaverse_dir = _current_location + "/" + metaverse_id
	_metaverse_scene_path = _metaverse_dir + "/" + metaverse_id + ".tscn"
	_metaverse_data_path = _metaverse_dir + "/" + metaverse_id + ".ma4d"
	_metaverse_dir_assets = _metaverse_dir + "/" + "assets"
	_metaverse_dir_tamt = _metaverse_dir + "/" + "tamt"
	_metaverse_dir_planets = _metaverse_dir + "/" + "planets"


func get_metaverse_scene_path(
		location: MAPOD4D_METAVERSE_LOCATION, metaverse_id: String):
	_current_location = get_multiverse_location(location)
	set_current_metaverse_paths(metaverse_id)
	return _metaverse_scene_path

func get_metaverse_element_path(
		location: MAPOD4D_METAVERSE_LOCATION,
		metaverse_id: String, element_name: String):
	_current_location = get_multiverse_location(location)
	set_current_metaverse_paths(metaverse_id)
	var ret_val = _metaverse_dir + "/" + element_name
	return ret_val


## build and load metaverses list
func metaverse_list_load(location: MAPOD4D_METAVERSE_LOCATION):
	var dir = null
	_choose_multiverse_location(location)
	dir = DirAccess.open(_current_location)

	if dir != null:
		var list_dir = dir.get_directories()
		for directory_name in list_dir:
			if dir.file_exists(_current_location + "/" + 
					directory_name + "/" + directory_name + ".ma4d"):
				_metaverse_list.push_front(directory_name)
#		## dir exists
#		var list_files = dir.get_files()
#		for file_name in list_files:
#			if file_name.ends_with("." + MAPOD4D_METAVERSE_EXT):
#				var file = FileAccess.open(
#					current_location + "/" + file_name, FileAccess.READ)
#				if file != null:
#					_json_check(file)
#					file = null
#				else:
#					print("FILEERROR")
	else:
		printerr("%s" % str(DirAccess.get_open_error()))


func metaverse_list_to_item_list(destination: ItemList):
	for element in _metaverse_list:
		destination.add_item(element)


func metaverse_list_clear():
	_metaverse_list.clear()


## build scaffold structure for metaverse
func metaverse_scaffold(
		location: MAPOD4D_METAVERSE_LOCATION,
		metaverse_id: String,
		v1: int, v2: int, v3: int, v4: int):
	var ret_val = {
		"response": false,
		"scenes_list": []
	}
	var dir = null
	_choose_multiverse_location(location)
	dir = DirAccess.open(_current_location)

	if dir != null:
		set_current_metaverse_paths(metaverse_id)
		if dir.dir_exists(_metaverse_dir) == false:
			if dir.make_dir(_metaverse_dir) == OK:
				var file = FileAccess.open(
						_metaverse_data_path, FileAccess.WRITE)
				var metaverse_info = {
							"id": metaverse_id,
							"v1": v1,
							"v2": v2,
							"v3": v3,
							"v4": v4,
						}
				print(metaverse_info)
				var metaverse_info_json = JSON.stringify(metaverse_info)
				file.store_line(metaverse_info_json)
				file = null
			dir.make_dir(_metaverse_dir_assets)
			dir.make_dir(_metaverse_dir_tamt)
			dir.make_dir(_metaverse_dir_planets)
			var metaverse_name = metaverse_id.substr(0,1).to_upper()
			metaverse_name += metaverse_id.substr(1)
			if _save_templ_scene(
					TEMPL_METAVERESE,
					_metaverse_dir + "/" + metaverse_id + ".tscn", 
					metaverse_name):
				if _save_templ_list_of_planets(
					TEMPL_LIST_OF_PLANET,
					_metaverse_dir + "/list_of_planets.tres",
				):
					ret_val.scenes_list.push_front(_metaverse_dir)
					ret_val.response = true
		else:
			printerr("Metaverse directory already exists")
	return ret_val


func metaverse_info_read_by_id(metaverse_id):
	set_current_metaverse_paths(metaverse_id)
	return metaverse_info_read(_metaverse_data_path)


func metaverse_info_read(source_file):
	var ret_val = false
	var resource = Mapod4dMa4dRes.new()
	var file = FileAccess.open(source_file, FileAccess.READ)
	if file != null:
		var data = file.get_line()
		var data_json = JSON.parse_string(data)
		if data_json != null:
			resource.id = data_json.id
			resource.v1 = data_json.v1
			resource.v2 = data_json.v2
			resource.v3 = data_json.v3
			resource.v4 = data_json.v4
			ret_val = true
	else:
		print(FileAccess.get_open_error())
		print(source_file)
	return {
		"ret_val": ret_val,
		"resource": resource
	}


## build scaffold structure for planet
func planet_scaffold(
		_location: MAPOD4D_METAVERSE_LOCATION,
		_metaverse_id: String,
		_planet_id,
		_planet_type: Mapod4dPlanetCoreRes.MAPOD4D_PLANET_TYPE):
	pass


## read all desktop metaverse for main menu itemlist
func metaverse_main_menu_list_read(destination: ItemList):
	var ret_val = false
	var metaverse_info
	var metaverse_string
	_metaverse_list.clear()
	metaverse_list_load(MAPOD4D_METAVERSE_LOCATION.M4D_DEV)
	for element in _metaverse_list:
		metaverse_string = "D " + element
		metaverse_info =  metaverse_info_read_by_id(element)
		if metaverse_info.ret_val == true:
			metaverse_string += " V " + str(metaverse_info.resource.v1)
			metaverse_string += "." + str(metaverse_info.resource.v2)
			metaverse_string += "." + str(metaverse_info.resource.v3)
			metaverse_string += "." + str(metaverse_info.resource.v4)
		var index = destination.add_item(metaverse_string)
		metaverse_info = {
			"location": MAPOD4D_METAVERSE_LOCATION.M4D_DEV,
			"id": element,
			"v1": metaverse_info.resource.v1,
			"v2": metaverse_info.resource.v2,
			"v3": metaverse_info.resource.v3,
			"v4": metaverse_info.resource.v4,
		}
		destination.set_item_metadata(index, metaverse_info)

# ----- private methods

func _choose_multiverse_location(location: MAPOD4D_METAVERSE_LOCATION):
	var ret_val = true
	_current_location = get_multiverse_location(location)
	return ret_val


## load packed template scene
## change root node name
## save new packed scene
func _save_templ_scene(
		source_name: String, dest_path: String, root_node_name: String):
	var ret_val = false
	if ResourceLoader.exists(TEMPL_DIR + source_name, "PackedScene"):
		var lscene: PackedScene = load(TEMPL_DIR + source_name)
		var node : Node = lscene.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
		node.set_name(root_node_name)
		var scene: PackedScene = PackedScene.new()
		scene.pack(node)
		var error = ResourceSaver.save(scene, dest_path)
		if error != OK:
			push_error("An error occurred while saving the scene to disk.")
		else:
			ret_val = true
	else:
		printerr(TEMPL_DIR + source_name + " not found")
	return ret_val


## load res template list_of_planets
## save new res
func _save_templ_list_of_planets(
		source_name: String, dest_path: String):
	var ret_val = false
#	if ResourceLoader.exists(
#		TEMPL_DIR + source_name, "Mapod4dListOfPlanetsRes"):
	if ResourceLoader.exists(TEMPL_DIR + source_name):
		var res: Mapod4dListOfPlanetsRes = load(TEMPL_DIR + source_name)
		var error = ResourceSaver.save(res, dest_path)
		if error != OK:
			push_error("An error occurred while saving the res to disk.")
		else:
			ret_val = true
	else:
		printerr(TEMPL_DIR + source_name + " not found")
	return ret_val


## check json file
func _json_check(_file):
	return true
#	const RVER = "(?<digit0>[0-9]+)\\.(?<digit1>[0-9]+)\\.(?<digit2>[0-9]+)\\.(?<digit3>[0-9]+)"
#	var regex = RegEx.new()
#	regex.compile(RVER)
#	## file exists
#	var json = JSON.new()
#	if json.parse(file.get_as_text()) == OK:
#		## json ok
#		print(str(json.data))
#		var version = regex.search(json.data.version)
#		if version != null:
#			## version ok
#			var data = {}
#			data["metaversefile"] = json.data.filename + \
#					"." + json.data.extension
#			data["core"] = version.get_string("digit0")
#			data["ver"] = version.get_string("digit1")
#			data["build"] = version.get_string("digit2")
#			data["subbuild"] = version.get_string("digit3")
#			var metaverse_file_exists = FileAccess.file_exists(
#					"users://metaverse" + "/" + data["metaversefile"])
#			if metaverse_file_exists == true:
#				print("OK")
#				_metaverse_files.push_back(data)
#			else:
#				print("METAVERSEERROR")
#		else:
#			print("VERSIONERROR")
#	else:
#		print("PARSEERROR")
