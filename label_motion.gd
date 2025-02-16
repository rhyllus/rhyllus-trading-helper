extends Node2D

var exited_left : bool = true
var exited_right : bool = true
var overlapped_area : Area2D
var left : bool = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	GlobalVariables.time_offset_minutes -= 15
	position.x -= 450
		
func _on_area_2d_area_entered_right(area: Area2D) -> void:
	GlobalVariables.time_offset_minutes += 15
	position.x += 450
