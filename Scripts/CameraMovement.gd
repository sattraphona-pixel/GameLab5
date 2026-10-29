# ----------------------------------------------------------------------------------- #
# ---------------------- 3D PLATFORMER CAMERA (SD STUDIOS, CC0) --------------------- #
# ----------------------------------------------------------------------------------- #

extends Node3D

# ---------- VARIABLES ---------- #

# Control Mouse Sensitivity through inspector or from here
@export var mouse_sensitivity := 0.2
@export var key_speed := 110.0   # degrees per second for Q/E and arrow keys

@onready var camera = $Camera3D
@onready var auto_rotate = false
@onready var timer = $CameraControlTimer

# ---------- FUNCTIONS ---------- #

func _ready():
	top_level = true
	timer.timeout.connect(_on_camera_control_timer_timeout)
	timer.start()
	# In a desktop build the mouse is captured; in a browser we use Q/E (or hold the left mouse button).
	if not OS.has_feature("web"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	rotation_degrees.x = -20

func _process(delta):
	var k = Input.get_axis("cam_left", "cam_right")
	if k != 0.0:
		rotation_degrees.y -= k * key_speed * delta
		rotation_degrees.y = wrapf(rotation_degrees.y, 0, 360)
		auto_rotate = false
		timer.start()
	var v = Input.get_axis("cam_up", "cam_down")
	if v != 0.0:
		rotation_degrees.x = clamp(rotation_degrees.x - v * key_speed * 0.5 * delta, -60, -5)

# Handling Camera Movement with the mouse
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		var dragging = Input.mouse_mode == Input.MOUSE_MODE_CAPTURED or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
		if not dragging:
			return
		rotation_degrees.x -= event.relative.y * mouse_sensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, -60, -5)
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		rotation_degrees.y = wrapf(rotation_degrees.y, 0, 360)
		auto_rotate = false
		timer.start()

func _on_camera_control_timer_timeout():
	auto_rotate = true
