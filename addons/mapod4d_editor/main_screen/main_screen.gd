# tool
@tool

# class_name

# extends
extends Control

## A brief description of your script.
##
## A more detailed description of the script.
##
## @tutorial:			http://the/tutorial1/url.com
## @tutorial(Tutorial2): http://the/tutorial2/url.com


# ----- signals

# ----- enums

# ----- constants

# ----- exported variables

# ----- public variables
var utils_instance = null

# ----- private variables
var _valid = false

# ----- onready variables
@onready var my_root_node = $ScrollContainer
@onready var button_refresh_metaverse_list = %RefreshMetaverseList
@onready var metaverse_location = %MetaverseLocation
@onready var metaverse_list = %MetaverseList
@onready var button_metaverse_create = %CreateMetaverse
@onready var in_metaverse_id = %MetaverseId

# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

# Called when the node enters the scene tree for the first time.
func _ready():
	if utils_instance == null:
		print("INVALID UTILS OBJECT")
	else:
		_valid = true
		button_refresh_metaverse_list.pressed.connect(
				_on_metaverse_list_refresh_pressed)
		metaverse_location.item_selected.connect(
				_on_metaverse_location_selected)
		button_metaverse_create.pressed.connect(_on_metaverse_create_pressed)


# ----- remaining built-in virtual methods

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass # Replace with function body.


# ----- public methods

# ----- private methods

func _metaverse_list_refresh(location_id):
	metaverse_list.clear()
	utils_instance.metaverse_list_clear()
	var location = metaverse_location.get_item_text(location_id)
	match location:
		"dev":
			utils_instance.metaverse_list_load(
					Mapod4dUtils.MAPOD4D_METAVERSE_LOCATION.DEV)
		"local":
			utils_instance.metaverse_list_load(
					Mapod4dUtils.MAPOD4D_METAVERSE_LOCATION.LOCAL)
		_:
			pass
	utils_instance.metaverse_list_to_item_list(metaverse_list)


func _on_metaverse_list_refresh_pressed():
	var location_id = metaverse_location.get_selected_id()
	if location_id >= 0:
		_metaverse_list_refresh(location_id)


func _on_metaverse_location_selected(index):
	_metaverse_list_refresh(index)


func _on_metaverse_create_pressed():
	var metaverse_id = in_metaverse_id.text
	if metaverse_id.length() > 0:
		var location_id = metaverse_location.get_selected_id()
		print(location_id)
		if location_id >= 0:
			utils_instance.metaverse_scaffold(location_id, metaverse_id)
