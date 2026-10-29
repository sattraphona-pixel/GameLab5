extends AnimatableBody3D

# Stand on it and it crumbles after a short time, then comes back.
@export var delay := 0.6
@export var respawn_time := 3.0

var _origin := Vector3.ZERO
var _triggered := false
@onready var _area: Area3D = $Trigger
@onready var _col: CollisionShape3D = $CollisionShape3D
@onready var _mesh: Node3D = $Mesh

@export var sunset := false

func _ready():
	if sunset:
		Tint.apply(self)
	_origin = position
	_area.body_entered.connect(_on_trigger)

func _on_trigger(body):
	if _triggered or not body.is_in_group("Player"):
		return
	_triggered = true
	AudioManager.break_sfx.play()
	# shake
	var shake = create_tween()
	for i in 6:
		shake.tween_property(_mesh, "position:x", 0.06 * (1 if i % 2 == 0 else -1), delay / 6.0)
	shake.tween_property(_mesh, "position:x", 0.0, 0.01)
	await shake.finished
	_col.set_deferred("disabled", true)
	var fall = create_tween()
	fall.tween_property(self, "position:y", _origin.y - 12.0, 1.0).set_ease(Tween.EASE_IN)
	fall.parallel().tween_property(_mesh, "scale", Vector3(0.2, 0.2, 0.2), 1.0)
	await fall.finished
	await get_tree().create_timer(respawn_time).timeout
	position = _origin
	_mesh.scale = Vector3.ONE
	_col.set_deferred("disabled", false)
	_triggered = false
