# ----------------------------------------------------------------------------------- #
# ---------- 3D PLATFORMER CONTROLLER (based on SD Studios Starter Kit, CC0) --------- #
# ---------- Modified for Lab 5: new character, hurt/respawn, bounce pad, flip ------- #
# ----------------------------------------------------------------------------------- #

extends CharacterBody3D

# ---------- VARIABLES ---------- #

@export_category("Player Properties")
@export var move_speed : float = 7.0
@export var jump_force : float = 9.0
@export var follow_lerp_factor : float = 6.0
@export var jump_limit : int = 2
@export var gravity_scale : float = 2.2

@export_group("Game Juice")
@export var jumpStretchSize := Vector3(0.8, 1.2, 0.8)

# State
var is_grounded = false
var can_double_jump = false
var dead = false
var _air_time = 0.0
var _coyote = 0.0
var _jump_buffer = 0.0

# Onready Variables
@onready var pivot = $Pivot                      # rotates to face the movement direction
@onready var model = $Pivot/FlipRoot             # the Flip animation rotates this node
@onready var anim_char = $Pivot/FlipRoot/Character/AnimationPlayer   # Idle / Run / Jump (from the model)
@onready var animation = $AnimationPlayer        # Flip / Hurt (made for this game)
@onready var spring_arm = %Gimbal

@onready var particle_trail = $ParticleTrail
@onready var footsteps = $Footsteps

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_scale

# ---------- FUNCTIONS ---------- #

func _ready():
	# give the character our own colours (red suit)
	var hero_mat = load("res://Assets/Materials/hero.tres")
	for m in $Pivot/FlipRoot/Character.find_children("*", "MeshInstance3D", true, false):
		m.material_override = hero_mat
	# The imported model uses the names idle / walk / jump.
	# Re-name them so they match the original kit: Idle, Run, Jump.
	var lib: AnimationLibrary = anim_char.get_animation_library("")
	for pair in [["idle", "Idle"], ["walk", "Run"], ["jump", "Jump"]]:
		if lib.has_animation(pair[0]) and not lib.has_animation(pair[1]):
			var a: Animation = lib.get_animation(pair[0])
			lib.add_animation(pair[1], a)
	lib.get_animation("Idle").loop_mode = Animation.LOOP_LINEAR
	lib.get_animation("Run").loop_mode = Animation.LOOP_LINEAR
	lib.get_animation("Jump").loop_mode = Animation.LOOP_NONE
	anim_char.play("Idle")
	GameManager.set_checkpoint(global_position + Vector3(0, 0.2, 0))

func _physics_process(delta):
	if dead:
		return
	get_input(delta)
	handle_jump(delta)
	player_animations()

	# Smoothly follow player's position (camera)
	spring_arm.position = lerp(spring_arm.position, position, delta * follow_lerp_factor)

	# Player Rotation
	if is_moving():
		var look_direction = Vector2(velocity.z, velocity.x)
		pivot.rotation.y = lerp_angle(pivot.rotation.y, look_direction.angle(), delta * 12)
		if spring_arm.auto_rotate:
			spring_arm.rotation.y = lerp_angle(spring_arm.rotation.y, look_direction.angle() - deg_to_rad(180), delta * 0.4)
			spring_arm.rotation.x = lerp_angle(spring_arm.rotation.x, deg_to_rad(-20), delta * 0.4)

	# landing sound
	var was_grounded = is_grounded
	is_grounded = is_on_floor()
	if is_grounded and not was_grounded and _air_time > 0.3:
		AudioManager.land_sfx.play()
		squash()
	_air_time = 0.0 if is_grounded else _air_time + delta

func handle_jump(delta):
	if is_on_floor():
		can_double_jump = true
		_coyote = 0.12
	else:
		_coyote -= delta
	_jump_buffer -= delta
	if Input.is_action_just_pressed("jump"):
		_jump_buffer = 0.12

	if _jump_buffer > 0.0:
		if _coyote > 0.0:
			perform_jump()
			_jump_buffer = 0.0
			_coyote = 0.0
		elif can_double_jump and not is_on_floor():
			perform_flip_jump()
			_jump_buffer = 0.0

	velocity.y -= gravity * delta

func perform_jump():
	AudioManager.jump_sfx.pitch_scale = 1.12
	AudioManager.jump_sfx.play()
	jumpTween()
	anim_char.play("Jump", 0.1)
	velocity.y = jump_force

func perform_flip_jump():
	can_double_jump = false
	AudioManager.jump_sfx.pitch_scale = 0.8
	AudioManager.jump_sfx.play()
	animation.play("Flip", -1, 1.5)   # somersault in the air
	velocity.y = jump_force * 0.95

# Called by the bounce pad
func bounce(power: float):
	velocity.y = power
	can_double_jump = true
	anim_char.play("Jump", 0.1)
	jumpTween()

func is_moving():
	return abs(velocity.z) > 0.1 || abs(velocity.x) > 0.1

func jumpTween():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", jumpStretchSize, 0.1)
	tween.tween_property(self, "scale", Vector3(1, 1, 1), 0.1)

func squash():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector3(1.2, 0.8, 1.2), 0.07)
	tween.tween_property(self, "scale", Vector3(1, 1, 1), 0.12)

# Get Player Input
func get_input(_delta):
	var move_direction := Vector3.ZERO
	move_direction.x = Input.get_axis("move_left", "move_right")
	move_direction.z = Input.get_axis("move_forward", "move_back")

	# Move The player Towards Spring Arm/Camera Rotation
	move_direction = move_direction.rotated(Vector3.UP, spring_arm.rotation.y).normalized()
	velocity = Vector3(move_direction.x * move_speed, velocity.y, move_direction.z * move_speed)
	move_and_slide()

# Handle Player Animations
func player_animations():
	particle_trail.emitting = false
	footsteps.stream_paused = true

	if is_on_floor():
		if is_moving():
			if anim_char.current_animation != "Run":
				anim_char.play("Run", 0.15)
			anim_char.speed_scale = 1.3
			particle_trail.emitting = true
			footsteps.stream_paused = false
		else:
			if anim_char.current_animation != "Idle":
				anim_char.play("Idle", 0.15)
			anim_char.speed_scale = 1.0
	else:
		if anim_char.current_animation != "Jump":
			anim_char.play("Jump", 0.1)

# ---------- Getting hurt / falling ---------- #

# Touching a trap: flash, then go back to the last checkpoint
func hurt():
	if dead:
		return
	dead = true
	GameManager.deaths += 1
	AudioManager.hurt_sfx.play()
	animation.play("Hurt")
	velocity = Vector3.ZERO
	await get_tree().create_timer(0.55).timeout
	_respawn()

# Falling off the island
func fall_respawn():
	if dead:
		return
	dead = true
	GameManager.deaths += 1
	AudioManager.hurt_sfx.play()
	await get_tree().create_timer(0.25).timeout
	_respawn()

func _respawn():
	global_position = GameManager.respawn_point
	velocity = Vector3.ZERO
	model.rotation = Vector3.ZERO
	model.scale = Vector3.ONE
	spring_arm.position = position
	dead = false
	animation.play("RESET")
