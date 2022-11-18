@tool
extends EditorPlugin


const main_panel = preload("res://addons/mapod4d_editor/main_screen/main_screen.tscn")
#const utils = preload("res://mapod4d_core/mapod4d_utils/mapod4d_utils.gd")

var main_panel_instance

func _enter_tree():
	main_panel_instance = main_panel.instantiate()
	main_panel_instance.utils_instance = Mapod4dUtils.new()
	if main_panel_instance.utils_instance != null:
		print("UTILS OBJECT CREATED")
	main_panel_instance.editor_interface = get_editor_interface()
	get_editor_interface().get_editor_main_screen().add_child(
			main_panel_instance)
	_make_visible(false)


func _exit_tree():
	if main_panel_instance:
		if main_panel_instance.utils_instance != null:
			main_panel_instance.queue_free()


func _has_main_screen():
	return true


func _make_visible(visible):
	if main_panel_instance:
		main_panel_instance.visible = visible

#func _handles(object):
#	print(object)


func _get_plugin_name():
	return "MAPOD4D"


func _get_plugin_icon():
	return get_editor_interface().get_base_control().get_theme_icon("Node", "EditorIcons")

