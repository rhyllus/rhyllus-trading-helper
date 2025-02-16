extends Node2D
class_name StaticCandle

var intervals : Array = ["1m", "5m", "15m", "30m", "60m", "4h", "1d", "1W", "1M"]

var price : float
var candle_floor : float
var upper_shadow : float
var lower_shadow : float
var open_time : int

func _draw() -> void:
	var candle_height = price - candle_floor
	var shadow_bottom = candle_floor - lower_shadow
	var shadow_top = upper_shadow - lower_shadow
	var candle_color : Color = Color.GREEN
	GlobalVariables.total_height += candle_height
	position.y = GlobalVariables.total_height
	if (candle_height < 0):
		candle_color = Color.RED
	draw_rect(Rect2(-1.5, shadow_bottom, 3, -shadow_top), candle_color)
	if (candle_height > -0.1 && candle_height < 0.2):
		draw_rect(Rect2(-10, 1, 20, 2), candle_color)
	else:
		draw_rect(Rect2(-10, 0, 20, -candle_height), candle_color)


func _on_area_2d_area_entered(area: Area2D) -> void:
	GlobalVariables.cameraY = position.y - ((price - candle_floor) / 2)
