extends Control

@onready var stats = $Stats

func _ready():
	_setup_hero()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	AudioManager.win_sfx.play()
	stats.text = "Coins collected: %d\nTime: %s\nDeaths: %d" % [GameManager.total_collected, GameManager.format_time(GameManager.time_elapsed), GameManager.deaths]
	$Buttons/AgainBtn.pressed.connect(func(): GameManager.start_game())
	$Buttons/MenuBtn.pressed.connect(func(): GameManager.go_menu())
	$Buttons/AgainBtn.grab_focus()

func _process(delta):
	var p = get_tree().current_scene.get_node_or_null("CamPivot")
	if p:
		p.rotate_y(delta * 0.25)

# the hero in the background wears the red suit and idles
func _setup_hero():
	var hero = get_tree().current_scene.get_node_or_null("Hero")
	if hero == null:
		return
	var mat = load("res://Assets/Materials/hero.tres")
	for m in hero.find_children("*", "MeshInstance3D", true, false):
		m.material_override = mat
	var ap: AnimationPlayer = hero.get_node_or_null("AnimationPlayer")
	if ap:
		ap.get_animation("idle").loop_mode = Animation.LOOP_LINEAR
		ap.play("idle")
