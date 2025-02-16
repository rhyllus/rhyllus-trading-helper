extends Camera2D

var horizontal_motion : bool = false
var mouse_last_posX : float
var mouse_posX : float
var last_motion : float = 0
@onready var time_disp : Node2D = $Time
@onready var time_left_collision : Area2D = $Time/LabelPivot2/Area2D
@onready var time_right_collision : Area2D = $Time/LabelPivot6/Area2D

func _input(event):
	if event is InputEventMouseMotion:
		if (horizontal_motion):
			last_motion = mouse_last_posX - event.position.x
			position.x += last_motion
			time_disp.position.x -= last_motion
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (time_left_collision.has_overlapping_areas()):
		GlobalVariables.time_offset_minutes -= 5
		time_disp.position.x -= 150
	elif (time_right_collision.has_overlapping_areas()):
		GlobalVariables.time_offset_minutes += 5
		time_disp.position.x += 150
	position.y = lerpf(position.y, GlobalVariables.cameraY, delta * Settings.camera_snap)
	if (last_motion != 0 && abs(last_motion) < 0.4):
		last_motion = 0
	else:
		last_motion = lerpf(last_motion, 0, delta * Settings.scroll_intertia)
	mouse_last_posX = get_viewport().get_mouse_position().x
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		horizontal_motion = true
	else:
		position.x += last_motion
		time_disp.position.x -= last_motion
		horizontal_motion = false
