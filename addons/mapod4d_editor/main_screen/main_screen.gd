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
#const TEMPL_DIR = "res://mapod4d_templates/"
#const TEMPL_METAVERESE = "mapod_4d_templ_metaverse.tscn"

# ----- exported variables

# ----- public variables
var utils_instance = null
var editor_interface = null

# ----- private variables
var _valid = false
var _templ_metaverse_exist = false
var _tmp_val = 0

# ----- onready variables
@onready var _my_root_node = $ScrollContainer
@onready var _button_refresh_metaverse_list = %RefreshMetaverseList
@onready var _metaverse_location = %MetaverseLocation
@onready var _metaverse_list = %MetaverseList
@onready var _button_create_metaverse = %CreateMetaverse
@onready var _input_metaverse_id = %MetaverseId
@onready var _editor_tab_container = %EditorTabContainer
@onready var _input_v1 = %V1
@onready var _input_v2 = %V2
@onready var _input_v3 = %V3
@onready var _input_v4 = %V4
@onready var _button_test = %Test

# ----- optional built-in virtual _init method

# ----- built-in virtual _ready method

# Called when the node enters the scene tree for the first time.
func _ready():
	## enable only for test
	_editor_tab_container.set_tab_disabled(2, true)
	
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
	_button_test.pressed.connect(
			_on_button_test_pressed)


# ----- remaining built-in virtual methods

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass # Replace with function body.


# ----- public methods

# ----- private methods

## TEST
func create_inherited_scene(
		_inherits: PackedScene, _root_name: String = "") -> PackedScene:
	if(_root_name == ""):
		_root_name = _inherits._bundled["names"][0];
	var scene := PackedScene.new();
	scene._bundled = {
		"base_scene": 0,
		"conn_count": 0,
		"conns": [],
		"editable_instances": [],
		"names": [_root_name],
		"node_count": 1,
		"node_paths": [],
		"nodes": [-1, -1, 2147483647, 0, -1, 0, 0],
		"variants": [_inherits],
		"version": 2
	}
	return scene;


## TEST
func save_scene():
	# Create the objects.
	var node = Node2D.new()
	var rigid = RigidBody2D.new()
	var collision = CollisionShape2D.new()

	# names
	node.set_name("Main")
	rigid.set_name("Body")
	collision.set_name("Collisione")

	# Create the object hierarchy.
	rigid.add_child(collision)
	node.add_child(rigid)

	rigid.set_owner(node)
	collision.set_owner(node)

	var scene = PackedScene.new()
	# Only `node` and `rigid` are now packed.
	var result = scene.pack(node)
	if result == OK:
		var error = ResourceSaver.save(scene, "res://peppo.tscn")  # Or "user://...
		if error != OK:
			push_error("An error occurred while saving the scene to disk.")


## TEST
func save_scene_in():
	var lscene: PackedScene = load("res://xx.tscn")
	var node : Node = lscene.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	print(node)
	node.set_name("Peppo" + str(_tmp_val))
	_tmp_val += 1
	print(node)
	var scene: PackedScene = PackedScene.new()
	scene.pack(node)
	print(_tmp_val)
	var error = ResourceSaver.save(scene, "res://peppo.tscn")  # Or "user://...
	if error != OK:
		push_error("An error occurred while saving the scene to disk.")
	else:
		editor_interface.reload_scene_from_path("res://peppo.tscn")

#	else:
#		var rfs = editor_interface.
#		if rfs != null:
#			rfs.scan()


### load packed template scene
### change root node name
### save new packed scene
#func _save_templ_scene(
#		source_name: String, dest_path: String, root_node_name: String):
#	if ResourceLoader.exists(TEMPL_DIR + source_name, "PackedScene"):
#		var lscene: PackedScene = load(TEMPL_DIR + source_name)
#		var node : Node = lscene.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
#		node.set_name(root_node_name)
#		var scene: PackedScene = PackedScene.new()
#		scene.pack(node)
#		var error = ResourceSaver.save(scene, dest_path)
#		if error != OK:
#			push_error("An error occurred while saving the scene to disk.")
#		else:
#			editor_interface.reload_scene_from_path(dest_path)
#	else:
#		printerr(TEMPL_DIR + source_name + " not found")


func _metaverse_list_refresh(location_id):
	if utils_instance == null:
		print("INVALID UTILS OBJECT")
	else:
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
			v1.length() + v2.length() + v3.length() + v4.length()) > 0:
		var location_id = _metaverse_location.get_selected_id()
		print(location_id)
		if location_id >= 0:
			var ret_val = utils_instance.metaverse_scaffold(
				location_id, metaverse_id,
				v1.to_int(), v2.to_int(), v3.to_int(), v4.to_int())

			## refresh
			var rfs = editor_interface.get_resource_filesystem()
			if rfs != null:
				rfs.scan()
			for scene in ret_val.scenes_list:
				editor_interface.reload_scene_from_path(scene)
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


func _on_button_test_pressed():
	print("button_test_pressed")
	save_scene_in()

