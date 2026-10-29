extends Control

# Main menu: Start / How to play / Quit. The 3D background spins slowly.

@onready var help_panel = $Help
@onready var cam_pivot = get_tree().current_scene.get_node_or_null("CamPivot")

func _ready():
	_setup_hero()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	AudioManager.play_music("menu")
	help_panel.visible = false
	$Buttons/StartBtn.pressed.connect(func(): AudioManager.coin_sfx.play(); GameManager.start_game())
	$Buttons/HelpBtn.pressed.connect(func(): help_panel.visible = not help_panel.visible)
	$Buttons/QuitBtn.pressed.connect(func(): get_tree().quit())
	if OS.has_feature("web"):
		$Buttons/QuitBtn.visible = false
	$Buttons/StartBtn.grab_focus()

func _process(delta):
	if cam_pivot:
		cam_pivot.rotate_y(delta * 0.15)

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
