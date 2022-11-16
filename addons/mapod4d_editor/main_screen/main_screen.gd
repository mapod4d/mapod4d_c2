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
@onready var _my_root_node = $ScrollContainer
@onready var _button_refresh_metaverse_list = %RefreshMetaverseList
@onready var _metaverse_location = %MetaverseLocation
@onready var _metaverse_list = %MetaverseList
@onready var _button_create_metaverse = %CreateMetaverse
@onready var _input_metaverse_id = %MetaverseId
@onready var _input_v1 = %V1
@onready var _input_v2 = %V2
@onready var _input_v3 = %V3
@onready var _input_v4 = %V4

# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

# Called when the node enters the scene tree for the first time.
func _ready():
	if utils_instance == null:
		print("INVALID UTILS OBJECT")
	else:
		_valid = true
		_button_refresh_metaverse_list.pressed.connect(
				_on_metaverse_list_refresh_pressed)
		_metaverse_location.item_selected.connect(
				_on_metaverse_location_selected)
		_button_create_metaverse.pressed.connect(
				_on_metaverse_create_pressed)
		_input_metaverse_id.text_changed.connect(
				_on_input_metaverse_id_text_changed)
		_input_v1.text_changed.connect(
				_on_input_v1_text_changed)
		_input_v2.text_changed.connect(
				_on_input_v2_text_changed)
		_input_v3.text_changed.connect(
				_on_input_v3_text_changed)
		_input_v4.text_changed.connect(
				_on_input_v4_text_changed)


# ----- remaining built-in virtual methods

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass # Replace with function body.


# ----- public methods

# ----- private methods

func _metaverse_list_refresh(location_id):
	_metaverse_list.clear()
	utils_instance.metaverse_list_clear()
	var location = _metaverse_location.get_item_text(location_id)
	match location:
		"dev":
			utils_instance.metaverse_list_load(
					Mapod4dUtils.MAPOD4D_METAVERSE_LOCATION.DEV)
		"local":
			utils_instance.metaverse_list_load(
					Mapod4dUtils.MAPOD4D_METAVERSE_LOCATION.LOCAL)
		_:
			pass
	utils_instance.metaverse_list_to_item_list(_metaverse_list)


# validation for integer
func _validate_integer_input(new_text, input_object):
	const allowed_characters = "[0-9]"
	var old_caret_column = input_object.caret_column
	var word = ''
	var regex = RegEx.new()
	regex.compile(allowed_characters)
	for valid_character in regex.search_all(new_text):
		word += valid_character.get_string()
	input_object.set_text(word)
	input_object.caret_column = old_caret_column


func _on_metaverse_list_refresh_pressed():
	var location_id = _metaverse_location.get_selected_id()
	if location_id >= 0:
		_metaverse_list_refresh(location_id)


func _on_metaverse_location_selected(index):
	_metaverse_list_refresh(index)


func _on_metaverse_create_pressed():
	var metaverse_id = _input_metaverse_id.text
	var v1 = _input_v1.text
	var v2 = _input_v2.text
	var v3 = _input_v3.text
	var v4 = _input_v4.text
	if (metaverse_id.length() + 
			v1.length() + v2.length() + v3.length() + v1.length()) > 0:
		var location_id = _metaverse_location.get_selected_id()
		print(location_id)
		if location_id >= 0:
			utils_instance.metaverse_scaffold(
				location_id, metaverse_id,
				v1.to_int(), v2.to_int(), v3.to_int(), v4.to_int())
	else:
		printerr("Metaverse ID, v1, v2, v3 and v4 connot be empty")


# validation for field metaverse ID
func _on_input_metaverse_id_text_changed(new_text):
	const allowed_characters = "[a-z0-9]"
	var old_caret_column = _input_metaverse_id.caret_column
	var word = ''
	var regex = RegEx.new()
	regex.compile(allowed_characters)
	for valid_character in regex.search_all(new_text):
		word += valid_character.get_string()
	_input_metaverse_id.set_text(word)
	_input_metaverse_id.caret_column = old_caret_column


func _on_input_v1_text_changed(new_text):
		_validate_integer_input(new_text, _input_v1)


func _on_input_v2_text_changed(new_text):
		_validate_integer_input(new_text, _input_v2)


func _on_input_v3_text_changed(new_text):
		_validate_integer_input(new_text, _input_v3)


func _on_input_v4_text_changed(new_text):
		_validate_integer_input(new_text, _input_v4)
