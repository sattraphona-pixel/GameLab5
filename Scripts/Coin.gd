extends Area3D

# ---------- VARIABLES ---------- #

# You can change these values from inspector!
@export_category("Properties")
@export var follow_speed := 6
@export var amplitude := 0.2
@export var frequency := 4

var time_passed = 0.0
var is_in_range = false
var collected = false

# Vector
var initial_position := Vector3.ZERO

@onready var player := get_tree().get_first_node_in_group("Player")

# ---------- FUNCTIONS ---------- #

func _ready():
	initial_position = position
	GameManager.register_coin()
	$Range.body_exited.connect(_on_range_body_exited)

func _process(delta):
	if collected:
		return
	coin_hover(delta)
	rotate_y(deg_to_rad(3))
	if is_in_range and player:
		follow_player(delta)

# Coin Hover Animation
func coin_hover(delta):
	time_passed += delta
	var new_y = initial_position.y + amplitude * sin(frequency * time_passed)
	position.y = new_y

func follow_player(delta):
	global_position += global_position.direction_to(player.global_position + Vector3(0, 0.5, 0)) * follow_speed * delta
	initial_position = position

# ---------- SIGNALS ---------- #

func _on_body_entered(body):
	# Delete The Coin and Add Score
	if body.is_in_group("Player") and not collected:
		collected = true
		GameManager.add_score()
		AudioManager.coin_sfx.play()
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector3.ZERO, 0.15)
		tween.tween_callback(queue_free)

func _on_range_body_entered(body):
	if body.is_in_group("Player"):
		is_in_range = true

func _on_range_body_exited(body):
	if body.is_in_group("Player"):
		is_in_range = false
