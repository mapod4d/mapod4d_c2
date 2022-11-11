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
	DEV = 0,
	LOCAL,
}

# ----- constants
const MAPOD4D_METAVERSE_EXT = "ma4d"

# ----- exported variables

# ----- public variables

# ----- private variables
var _current_location = ""
var _metaverse_list = []

# ----- onready variables


# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# ----- remaining built-in virtual methods

# ----- public methods

## load metaverses list
func metaverse_list_load(location: MAPOD4D_METAVERSE_LOCATION):
	var dir = null
	if _choose_metaverse_location(location) == true:
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
		print("%s" % str(DirAccess.get_open_error()))


func metaverse_list_to_item_list(destination: ItemList):
	for element in _metaverse_list:
		destination.add_item(element)


func metaverse_list_clear():
	_metaverse_list.clear()


func metaverse_scaffold(
		location: MAPOD4D_METAVERSE_LOCATION, metaverse_id: String):
	var dir = null
	if _choose_metaverse_location(location) == true:
		dir = DirAccess.open(_current_location)

	if dir != null:
		var metaverse_path = _current_location + "/" + metaverse_id
		var metaverse_entry = metaverse_path + "/metaverse"
		var metaverse_data = metaverse_path + "/" + metaverse_id + ".ma4d"
		if dir.dir_exists(metaverse_path) == false:
			if dir.make_dir(metaverse_path) == OK:
				if dir.make_dir(metaverse_entry) == OK:
					var file = FileAccess.open(metaverse_data, FileAccess.WRITE)
					var metaverse_info = {
								"name": "",
								"v1":  2,
								"v2":  0,
								"v3":  0,
								"v4":  0,
							}
					metaverse_info.name = str(metaverse_id)
					var metaverse_info_json = JSON.stringify(metaverse_info)
					file.store_line(metaverse_info_json)
					file = null
		else:
			print("ALREADY EXISTS")


func metaverse_info_read(source_file):
	var ret_val = false
	var resource = BaseMeMapod4dRes.new()
	var file = FileAccess.open(source_file, FileAccess.READ)
	if file != null:
		var data = file.get_line()
		var data_json = JSON.parse_string(data)
		if data_json != null:
			resource.name = str(data_json.name)
			resource.v1 = data_json.v1
			resource.v2 = data_json.v2
			resource.v3 = data_json.v3
			resource.v4 = data_json.v4
	return [ret_val, resource]


# ----- private methods

func _choose_metaverse_location(location: MAPOD4D_METAVERSE_LOCATION):
	var ret_val = true
	_current_location = ""
	match location:
		Mapod4dUtils.MAPOD4D_METAVERSE_LOCATION.LOCAL:
			_current_location = "res://mapod4d_multiverse_local"
		Mapod4dUtils.MAPOD4D_METAVERSE_LOCATION.DEV:
			_current_location = "res://mapod4d_multiverse_dev"
		_:
			print("invalid metaverse location")
			ret_val = false
	return ret_val


## check json file
func _json_check(file):
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
