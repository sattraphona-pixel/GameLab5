extends Node
# Global game state (autoload). Keeps coins, level progress, respawn point and the screen fade.

signal coins_changed
signal hint(text: String)

const LEVELS := ["res://Scenes/Level1.tscn", "res://Scenes/Level2.tscn"]
const LEVEL_NAMES := ["LEVEL 1 : Sunny Sky Garden", "LEVEL 2 : Crystal Sunset"]
const MENU_SCENE := "res://Scenes/Menu.tscn"
const WIN_SCENE := "res://Scenes/Win.tscn"

var score := 0            # coins collected in the current level
var total_coins := 0      # coins that exist in the current level
var total_collected := 0  # coins collected in the whole run
var level_index := 0
var deaths := 0
var time_elapsed := 0.0
var running := false
var respawn_point := Vector3(0, 2, 0)

var _fade: ColorRect
var _changing := false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	var layer := CanvasLayer.new()
	layer.layer = 100
	add_child(layer)
	_fade = ColorRect.new()
	_fade.color = Color(0.05, 0.05, 0.12, 1)
	_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fade.set_anchors_preset(Control.PRESET_FULL_RECT)
	_fade.modulate.a = 0.0
	layer.add_child(_fade)

func _process(delta):
	if running:
		time_elapsed += delta

# ---------- Game flow ---------- #

func start_game():
	level_index = 0
	deaths = 0
	time_elapsed = 0.0
	total_collected = 0
	running = true
	load_level(0)

func load_level(i: int):
	level_index = i
	score = 0
	total_coins = 0
	change_scene(LEVELS[i])

func next_level():
	if level_index + 1 >= LEVELS.size():
		running = false
		change_scene(WIN_SCENE)
	else:
		load_level(level_index + 1)

func restart_level():
	total_collected -= score
	load_level(level_index)

func go_menu():
	running = false
	change_scene(MENU_SCENE)

func change_scene(path: String):
	if _changing:
		return
	_changing = true
	var tw := create_tween()
	tw.tween_property(_fade, "modulate:a", 1.0, 0.3)
	await tw.finished
	get_tree().change_scene_to_file(path)
	await get_tree().process_frame
	await get_tree().process_frame
	var tw2 := create_tween()
	tw2.tween_property(_fade, "modulate:a", 0.0, 0.4)
	await tw2.finished
	_changing = false

# ---------- Coins ---------- #

func register_coin():
	total_coins += 1
	coins_changed.emit()

func add_score():
	score += 1
	total_collected += 1
	coins_changed.emit()
	if score == total_coins:
		hint.emit("All coins collected!  Go to the door!")

func all_collected() -> bool:
	return score >= total_coins

func set_checkpoint(pos: Vector3):
	respawn_point = pos

func format_time(t: float) -> String:
	return "%02d:%02d" % [int(t) / 60, int(t) % 60]
