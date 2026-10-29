extends Node3D

# Root script of every level scene.
@export var level_index := 0
@export var music_track := "level1"
@export var start_camera_yaw := 0.0   # degrees, so the camera looks along the level

func _enter_tree():
	# reset the counters before the coins register themselves
	GameManager.level_index = level_index
	GameManager.score = 0
	GameManager.total_coins = 0
	GameManager.running = true

func _ready():
	AudioManager.play_music(music_track)
	var gimbal = get_node_or_null("Player/Gimbal")
	if gimbal:
		gimbal.rotation_degrees.y = start_camera_yaw
