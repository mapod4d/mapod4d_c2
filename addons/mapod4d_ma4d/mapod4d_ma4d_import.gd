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
	return "tres"


func _get_resource_type():
	return "BaseMeMapod4dRes"


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
	var ret_val = false
	var utils = Mapod4dUtils.new()
	var metaverse_info = utils.metaverse_info_read(source_file)
	if metaverse_info[0] == true:
		ret_val = ResourceSaver.save(
			metaverse_info[1], "%s.%s" % [save_path, _get_save_extension()])
	else:
		var resource = Mapod4dMa4dRes.new()
		ret_val = ResourceSaver.save(
			metaverse_info[1], "%s.%s" % [save_path, _get_save_extension()])
#	var resource = BaseMeMapod4dRes.new()
#	var file = FileAccess.open(source_file, FileAccess.READ)
#	if file != null:
#		var data = file.get_line()
#		var data_json = JSON.parse_string(data)
#		if data_json != null:
#			resource.name = str(data_json.name)
#			resource.v1 = data_json.v1
#			resource.v2 = data_json.v2
#			resource.v3 = data_json.v3
#			resource.v4 = data_json.v4
	utils.free()
	return ret_val

