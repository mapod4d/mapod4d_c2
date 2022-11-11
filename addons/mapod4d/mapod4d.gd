@tool
extends EditorPlugin

var dock = null
var metaverse_id = null

const base_dev_path = "res://mapod4d_multiverses_dev/"
const base_loc_path = "res://mapod4d_multiverses_loc/"
const ma4d_ext = "ma4d"

func _enter_tree():
	# Initialization of the plugin goes here.
	print("MAPOD4D plugin start")
	dock = preload("res://addons/mapod4d/mapod4d.tscn").instantiate()
	var button_create = dock.get_node_or_null("%ButtonCreate")
	if button_create != null:
		print("button_create found")
		button_create.pressed.connect(_on_button_create_pressed)
	metaverse_id = dock.get_node_or_null("%MetaverseID")
	if metaverse_id != null:
		print("metaverse_id found")
		metaverse_id.text_changed.connect(_on_metaverse_id_text_changed)
	## Add the loaded scene to the docks.
	add_control_to_dock(DOCK_SLOT_LEFT_UL, dock)
	## Note that LEFT_UL means the left of the editor, upper-left dock.


func _exit_tree():
	# Clean-up of the plugin goes here.
	print("MAPOD4D plugin end")
	## Clean-up of the plugin goes here.
	# Remove the dock.
	remove_control_from_docks(dock)
	# Erase the control from the memory.
	dock.free()


func _on_button_create_pressed():
	print("_on_button_create_pressed()")
	var file = FileAccess.open(
			base_dev_path + "puppo+" + "." + ma4d_ext, FileAccess.WRITE)
	if file != null:
		print("file opened")
		file.store_string("content")
		file.flush()
	file = null


func _on_metaverse_id_text_changed(new_text):
	const allowed_characters = "[a-z0-9]"
	var old_caret_column = metaverse_id.caret_column
	var word = ''
	var regex = RegEx.new()
	regex.compile(allowed_characters)
	for valid_character in regex.search_all(new_text):
		word += valid_character.get_string()
	metaverse_id.set_text(word)
	metaverse_id.caret_column = old_caret_column

