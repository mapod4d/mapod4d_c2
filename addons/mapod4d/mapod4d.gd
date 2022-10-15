@tool
extends EditorPlugin

var dock = null

func _enter_tree():
	# Initialization of the plugin goes here.
	print("MAPOD4D plugin start")
	dock = preload("res://addons/mapod4d/mapod4d.tscn").instantiate()
	## Add the loaded scene to the docks.
	add_control_to_dock(DOCK_SLOT_LEFT_BL, dock)
	## Note that LEFT_UL means the left of the editor, upper-left dock.


func _exit_tree():
	# Clean-up of the plugin goes here.
	print("MAPOD4D plugin end")
	## Clean-up of the plugin goes here.
	# Remove the dock.
	remove_control_from_docks(dock)
	# Erase the control from the memory.
	dock.free()
