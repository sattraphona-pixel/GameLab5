extends Area3D

# The exit door. It opens when every coin in the level is collected.
@onready var portal: Node3D = $Portal
@onready var disc: MeshInstance3D = $Portal/Disc
@onready var label: Label3D = $Label
var _open := false
var _used := false
var _t := 0.0

func _ready():
	body_entered.connect(_on_body_entered)
	_update_state(true)
	GameManager.coins_changed.connect(func(): _update_state(false))

func _process(delta):
	_t += delta
	portal.rotation.z += delta * (2.0 if _open else 0.4)
	var open_now = GameManager.all_collected()
	if open_now != _open:
		_update_state(false)

func _update_state(first: bool):
	_open = GameManager.all_collected() and GameManager.total_coins > 0
	var mat := disc.material_override as StandardMaterial3D
	if _open:
		mat.albedo_color = Color(0.3, 1.0, 0.8, 0.85)
		mat.emission = Color(0.1, 0.9, 0.7)
		label.text = "EXIT"
		if not first:
			AudioManager.door_sfx.play()
	else:
		mat.albedo_color = Color(1.0, 0.3, 0.3, 0.85)
		mat.emission = Color(0.8, 0.1, 0.1)
		label.text = "LOCKED  %d/%d" % [GameManager.score, GameManager.total_coins]

func _on_body_entered(body):
	if _used or not body.is_in_group("Player"):
		return
	if GameManager.all_collected():
		_used = true
		AudioManager.win_sfx.play()
		GameManager.next_level()
	else:
		AudioManager.locked_sfx.play()
		GameManager.hint.emit("Collect all coins first!  (%d/%d)" % [GameManager.score, GameManager.total_coins])
