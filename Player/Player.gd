extends KinematicBody


onready var root : Spatial = get_parent()
onready var label_debug : Label = $UI/Label_Debug
onready var label_timer : Label = $UI/MatchInfo/HBoxContainer/Label_Time
onready var label_score : Label = $UI/MatchInfo/HBoxContainer/Label_Score
onready var label_accuracy : Label = $UI/MatchInfo/HBoxContainer/Label_Accuracy
onready var crosshair : Control = $UI/Crosshair
onready var startup_info : Control = $UI/StartupInfo
onready var label_notification : Label = $UI/Notification/Panel/Label_Notification
onready var animation_Player : AnimationPlayer = $UI/AnimationPlayer

onready var camera : Camera = $Camera
onready var raycast : RayCast = camera.get_node("RayCast")
const MIN_LOOK_ANGLE : float = -75.0
const MAX_LOOK_ANGLE : float = 75.0
var look_sensitivity : float = 0.05

const SCORE_HIT : int = 100
var shoot : int = 0
var target_hit : int = 0
var score : int = 0


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Hide and lock centered mouse cursor
	startup()

func startup() -> void:
	crosshair.visible = false
	startup_info.visible = true
	shoot = 0
	target_hit = 0
	score = 0
	label_timer.text = "01:00"
	label_score.text = "0"
	label_accuracy.text = "0%"

func _input(event) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			rotation.y += -deg2rad(event.relative.x * look_sensitivity)
			camera.rotation.x += -deg2rad(event.relative.y * look_sensitivity)
			camera.rotation.x = clamp(camera.rotation.x, deg2rad(MIN_LOOK_ANGLE), deg2rad(MAX_LOOK_ANGLE))

func _physics_process(_delta) -> void:
	label_debug.text = "FPS: " + str(Engine.get_frames_per_second())
	
	if Input.is_action_just_pressed("left_click"):
		if root.isStarting == 0:
			root.start_game()
			startup_info.visible = false
			crosshair.visible = true
		
		elif root.isStarting == 2:
			var target_size = root.target_group.get_child(0).get_size()
			shoot += 1
			if raycast.is_colliding() and raycast.get_collider().is_in_group("enemy"):
				# Hit
				target_hit += 1
				score += SCORE_HIT / target_size
				raycast.get_collider().randomize_position()
				Audio.play("Hit")
			else:
				# Miss
				score -= (SCORE_HIT / target_size) / 5
			update_ui()

# Player Score -----------------------------------------------------------------
func update_ui() -> void:
	label_score.text = str(get_score())
	label_accuracy.text = str(get_accuracy()) + "%"

func get_score() -> int:
	return score

func get_accuracy() -> float:
	if shoot != 0:
		return stepify(float(target_hit) / float(shoot) * 100, 0.01)
	return 0.0

func get_kill_per_second() -> float:
	return stepify(float(target_hit) / 60.0, 0.01)

func get_avg_time_to_kill() -> String:
	if target_hit != 0:
		return str(int((60.0 / float(target_hit)) * 1000))
	return "-"

# Notification -----------------------------------------------------------------
func show_notification(text) -> void:
	label_notification.text = text
	animation_Player.play("Notification")
	Audio.play("Notification")

func set_distance(distance) -> void:
	translation.z = distance;
