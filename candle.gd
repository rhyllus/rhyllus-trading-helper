extends Node2D

@onready var data = $KlinesRequest
@onready var timer = $Timer
@onready var refresh_rate = timer.wait_time

var intervals : Array = ["1m", "5m", "15m", "30m", "60m", "4h", "1d", "1W", "1M"]

var URL : String
var price_lerp : float = 0
var price : float = 0
var candle_floor : float
var upper_shadow : float
var lower_shadow : float
var open_time : int
var request_pending : bool = false

func get_data() -> void:
	if (Settings.oracle == 0):
		URL = "https://api.mexc.com/api/v3/klines?symbol=BTCUSDT&limit=1&interval=" + intervals[Settings.interval]
	data.request(URL)

func _ready() -> void:
	get_data()
	request_pending = true

func _draw() -> void:
	var candle_height = price_lerp - candle_floor 
	var shadow_bottom = candle_floor - lower_shadow
	var shadow_top = upper_shadow - lower_shadow
	var candle_color : Color = Color.GREEN
	if (candle_height < 0):
		candle_color = Color.RED
	if (candle_height > -0.1 && candle_height < 0.1):
		draw_rect(Rect2(-10, 1, 20, 2), candle_color)
	draw_rect(Rect2(-10, 0, 20, -candle_height), candle_color)
	draw_rect(Rect2(-1, shadow_bottom, 2, -shadow_top), candle_color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (price_lerp == 0):
		price_lerp = price
	else:
		price_lerp = lerpf(price_lerp, price, delta * Settings.interpolation_speed)
	queue_redraw()
	if(timer.is_stopped()):
		timer.start()

func _on_timer_timeout() -> void:
	if (!request_pending):
		get_data()
		request_pending = true

func _on_http_request_2_request_completed(_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	request_pending = false
	var results : String = body.get_string_from_utf8()
	open_time = int(results.get_slice(',', 0))
	price = float(results.get_slice('"', 7))
	candle_floor = float(results.get_slice('"', 1))
	upper_shadow = float(results.get_slice('"', 3))
	lower_shadow = float(results.get_slice('"', 5))


func _on_area_2d_area_entered(area: Area2D) -> void:
	GlobalVariables.cameraY = position.y - ((price - candle_floor) / 2)
