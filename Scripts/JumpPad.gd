extends Area3D

# A bounce pad that launches the player high into the air.
@export var power := 17.0

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.bounce(power)
		AudioManager.pad_sfx.play()
		var tw = create_tween()
		tw.tween_property($Mesh, "scale", Vector3(1.2, 0.4, 1.2), 0.08)
		tw.tween_property($Mesh, "scale", Vector3.ONE, 0.25).set_trans(Tween.TRANS_ELASTIC)
