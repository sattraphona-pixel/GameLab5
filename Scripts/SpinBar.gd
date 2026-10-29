extends Area3D

# A spinning blade bar that rotates around the Y axis.
@export var speed := 1.6   # radians per second (negative = other direction)

func _ready():
	body_entered.connect(func(b): if b.is_in_group("Player"): b.hurt())

func _physics_process(delta):
	rotate_y(speed * delta)
