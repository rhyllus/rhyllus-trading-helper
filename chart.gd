extends Node2D

var intervals : Array = ["1m", "5m", "15m", "30m", "60m", "4h", "1d", "1W", "1M"]
var CandleScene = preload("res://static_candle.tscn")

@onready var historical_candle_root = $Historical
@onready var candle_raw_data = $HistoricalDataReq
@onready var timestamp_source = $Realtime
var timestamp : int = 0
var first_draw : bool = true
var historical_data : Array
var URL : String
# Number of historical candles to be drawn
@export var depth : int = 100  

func get_data() -> void:
	if Settings.oracle == 0:
		URL = "https://api.mexc.com/api/v3/klines?symbol=BTCUSDT&limit=" + str(depth) + "&interval=" + intervals[Settings.interval]
	candle_raw_data.request(URL)

func clear_instance() -> void:
	GlobalVariables.total_height = 0
	for child in historical_candle_root.get_children():
		historical_candle_root.remove_child(child)
		child.queue_free()
		
# Create and position candles based on historical data
func candle_instance(candle_data: Array, index: int) -> void:
	var candle = CandleScene.instantiate()
	candle.price = candle_data[4]
	candle.candle_floor = candle_data[1]
	candle.upper_shadow = candle_data[2]
	candle.lower_shadow = candle_data[3]
	historical_candle_root.add_child(candle)
	candle.queue_redraw()
	candle.position.x = index * -30

func _ready() -> void:
	get_data()

func _process(_delta: float) -> void:
	if (timestamp != 0 && (timestamp != timestamp_source.open_time)):
		timestamp = timestamp_source.open_time
		clear_instance()
		get_data()
	timestamp = timestamp_source.open_time

# Only run once after data is received, not in _process
func _on_historical_data_req_request_completed(_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	historical_data = json.data
	historical_data.reverse()
	historical_data.remove_at(0)
	draw_historical_candles()

func draw_historical_candles() -> void:
	for i in range(historical_data.size()):
		candle_instance(historical_data[i], i + 1)
