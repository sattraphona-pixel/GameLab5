extends AnimatableBody3D

# A platform that slides back and forth. Set "offset" (how far it moves) in the inspector.
@export var offset := Vector3(6, 0, 0)
@export var duration := 3.0   # seconds for one way
@export var phase := 0.0      # 0..1 start offset in the cycle

var _origin := Vector3.ZERO
var _t := 0.0

@export var sunset := false

func _ready():
	if sunset:
		Tint.apply(self)
	sync_to_physics = true
	_origin = position
	_t = phase * duration * 2.0

func _physics_process(delta):
	_t += delta
	var w = fposmod(_t, duration * 2.0) / duration
	var k = 0.5 - 0.5 * cos(PI * w)   # smooth 0..1..0
	position = _origin + offset * k
