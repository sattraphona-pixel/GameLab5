extends Area3D

# When the player falls off the islands, send them back to the last checkpoint.

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.fall_respawn()
