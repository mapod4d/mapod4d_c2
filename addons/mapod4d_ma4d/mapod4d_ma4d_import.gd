@tool
extends EditorImportPlugin


enum Presets { DEFAULT }


func _get_importer_name():
	return "mapod4d.ma4d"


func _get_visible_name():
	return "Mapod4D Metaverse"


func _get_recognized_extensions():
	return ["ma4d"]


func _get_save_extension():
	return "mvmapod4d"


func _get_resource_type():
	return "Res"


func _get_priority():
	return 1.0


func _get_import_order():
	return 0


func _get_preset_count():
	return Presets.size()


func _get_preset_name(preset):
	match preset:
		Presets.DEFAULT:
			return "Default"
		_:
			return "Unknown"


func _get_import_options(preset, preset_index):
	match preset:
		Presets.DEFAULT:
			return [{
						"name": "use_red_anyway",
						"default_value": false
					}]
		_:
			return []


func _get_option_visibility(path, option_name, options):
	return true


func _import(source_file, save_path, options, r_platform_variants, r_gen_files):
	var resource = Resource.new()
	return ResourceSaver.save(
		resource, "%s.%s" % [save_path, _get_save_extension()])

