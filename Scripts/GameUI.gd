extends Control

# In-game HUD: coin counter, level name, timer, deaths, hints and a pause menu.

@onready var coinsLabel = $CoinsLabel
@onready var levelLabel = $LevelLabel
@onready var timeLabel = $TimeLabel
@onready var deathLabel = $DeathLabel
@onready var hintLabel = $HintLabel
@onready var pausePanel = $PausePanel

var _hint_tween: Tween

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	levelLabel.text = GameManager.LEVEL_NAMES[GameManager.level_index]
	GameManager.hint.connect(show_hint)
	pausePanel.visible = false
	$PausePanel/Box/ResumeBtn.pressed.connect(_toggle_pause)
	$PausePanel/Box/RestartBtn.pressed.connect(func(): get_tree().paused = false; GameManager.restart_level())
	$PausePanel/Box/MenuBtn.pressed.connect(func(): get_tree().paused = false; GameManager.go_menu())
	show_hint("WASD = move   SPACE = jump (press twice = double jump)   Q / E = turn camera", 6.0)

func _process(_delta):
	coinsLabel.text = "x %d / %d" % [GameManager.score, GameManager.total_coins]
	timeLabel.text = "TIME  " + GameManager.format_time(GameManager.time_elapsed)
	deathLabel.text = "DEATHS  %d" % GameManager.deaths

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		_toggle_pause()
	elif event.is_action_pressed("restart") and not get_tree().paused:
		GameManager.restart_level()

func _toggle_pause():
	var p = not get_tree().paused
	get_tree().paused = p
	pausePanel.visible = p
	if p:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif not OS.has_feature("web"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func show_hint(text: String, seconds: float = 2.5):
	hintLabel.text = text
	hintLabel.modulate.a = 1.0
	if _hint_tween:
		_hint_tween.kill()
	_hint_tween = create_tween()
	_hint_tween.tween_interval(seconds)
	_hint_tween.tween_property(hintLabel, "modulate:a", 0.0, 0.6)
