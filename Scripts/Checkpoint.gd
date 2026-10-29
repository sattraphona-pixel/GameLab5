extends Area3D

# Touch the flag to save your respawn position.
var active := false

@export var sunset := false

func _ready():
	if sunset:
		Tint.apply(self)
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("Player") and not active:
		active = true
		GameManager.set_checkpoint(global_position + Vector3(0, 1.0, 0))
		AudioManager.checkpoint_sfx.play()
		GameManager.hint.emit("Checkpoint saved!")
		var flag = get_node_or_null("Flag")
		if flag:
			var tw = create_tween()
			tw.tween_property(flag, "scale", flag.scale * 1.4, 0.15)
			tw.tween_property(flag, "scale", flag.scale, 0.2)
