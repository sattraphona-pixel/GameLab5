extends Area3D

# Anything that hurts the player on touch (spikes, spinning blades ...).
# The player respawns at the last checkpoint.

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.hurt()
