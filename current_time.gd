extends Label

var current_time : Dictionary
@export var time_offset : int

func gen_offset_by_minute(offset : int) -> String:
	var dict_from_system : Dictionary = Time.get_datetime_dict_from_system()
	var unix_from_system : int = Time.get_unix_time_from_system()
	var timezone_diff : int = (Time.get_datetime_dict_from_unix_time(unix_from_system).hour - dict_from_system.hour) * 3600
	var timedict : Dictionary = Time.get_datetime_dict_from_unix_time(unix_from_system - timezone_diff + ((time_offset + GlobalVariables.time_offset_minutes) * 60))
	var result : String
	if (timedict.minute < 10):
		result = str(timedict.hour) + ":0" + str(timedict.minute)
	else:
		result = str(timedict.hour) + ':' + str(timedict.minute)
	return result

func _process(_delta: float) -> void:
	current_time = Time.get_datetime_dict_from_system()
	text = gen_offset_by_minute(time_offset)
