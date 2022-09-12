extends Spatial


var timer : Timer = Timer.new()
const MAX_TIME : int = 60 # In seconds

var isStarting : int = 0 # 0 = not started, 1 = starting..., 2 = started, 3 = ended
onready var target_group : Spatial = $TargetGroup


func _ready() -> void:
	load_target()
	load_config()
	startup()
	init_timer()

func startup() -> void:
	isStarting = 0
	Audio.stop()

func start_game() -> void:
	if isStarting == 0:
		isStarting = 1
		Audio.play("Tick", 4.1, false)
		start_timer(5)

# Target -----------------------------------------------------------------------
func load_target() -> void:
	for _i in range(2):
		var target_obj = load("res://Enemy/Target.tscn").instance()
		target_group.add_child(target_obj)

# Config -----------------------------------------------------------------------
func load_config() -> void:
	var settings = load("res://Menu/Settings/Settings.tscn").instance()
	settings.visible = false
	$Player.add_child(settings)
	yield(get_tree().create_timer(0.1), "timeout")
	settings.queue_free()

# Timer ------------------------------------------------------------------------
func init_timer() -> void:
	timer.one_shot = true
	if timer.connect("timeout", self, "timer_timeout") == OK:
		add_child(timer)

func start_timer(time) -> void:
	timer.start(time)

func _process(_delta) -> void:
	if isStarting == 1 or isStarting == 2:
		update_timer_ui()

func update_timer_ui() -> void:
	if timer != null:
		$Player.label_timer.text = seconds_to_time_format(timer.get_time_left())

func timer_timeout() -> void:
	if timer.is_stopped():
		if isStarting == 1: # Game Started
			isStarting = 2
			Audio.play("Start", 0, false)
			start_timer(MAX_TIME)
		elif isStarting == 2: # Game Ended
			isStarting = 3
			open_menu()

func seconds_to_time_format(time) -> String:
	var seconds_to_minutes : float = 0.0
	var separate_time : Array
	var minutes : String = ""
	var seconds : String = ""
	
	seconds_to_minutes = int(time)
	seconds_to_minutes /= 60 # Divided it by 60 (1 minute)
	seconds_to_minutes = stepify(seconds_to_minutes, 0.01) # So it only have 2 digits after floating point
	
	separate_time = str(seconds_to_minutes).split(".")
	
	minutes = separate_time[0]
	if separate_time.size() >= 2:
		if separate_time[1].length() >= 2: # The seconds need to be converted to from decimals value to time format
			seconds = str(round(float(separate_time[1]) * 60 / 100))
		else:
			seconds = str(round(float(separate_time[1]) * 10 * 60 / 100))
	else:
		seconds = "00"
		
	if minutes.length() == 1:
		minutes = "0" + minutes
	if seconds.length() == 1:
		seconds = "0" + seconds
	
	return str(minutes + ":" + seconds)

# Menu -------------------------------------------------------------------------
func _input(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		open_menu()

func open_menu() -> void:
	if not has_node("EscMenu"):
		var esc = load("res://Menu/EscMenu/EscMenu.tscn").instance()
		add_child(esc)
		get_tree().paused = true
