extends Node

# ---------- VARIABLES ---------- #

# References (these nodes are children of the AudioManager autoload scene)
@onready var jump_sfx = $JumpSfx
@onready var coin_sfx = $CoinSfx
@onready var hurt_sfx = $HurtSfx
@onready var pad_sfx = $PadSfx
@onready var door_sfx = $DoorSfx
@onready var checkpoint_sfx = $CheckpointSfx
@onready var locked_sfx = $LockedSfx
@onready var land_sfx = $LandSfx
@onready var win_sfx = $WinSfx
@onready var break_sfx = $BreakSfx
@onready var music = $Music

var _tracks := {
	"menu": preload("res://Assets/Audio/Music/sky_garden.ogg"),
	"level1": preload("res://Assets/Audio/Music/sky_garden.ogg"),
	"level2": preload("res://Assets/Audio/Music/crystal_sunset.ogg"),
}
var _current := ""

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	music.finished.connect(func(): music.play())

func play_music(track: String):
	if track == _current and music.playing:
		return
	_current = track
	music.stream = _tracks[track]
	music.play()
