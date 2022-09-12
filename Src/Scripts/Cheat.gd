extends Node

# Nothing to see here

onready var root : Spatial = get_parent().get_node("World")
onready var target_group : Spatial = root.get_node("TargetGroup")
onready var player : KinematicBody = root.get_node("Player")

const MOUSE_SPEED : int = 30

var isCheating : bool = false
var timer_input : Timer =  Timer.new()
var key_input : String = ""
var target : int = -1


func _ready() -> void:
	if timer_input.connect("timeout", self, "input_timeout") == OK:
		add_child(timer_input)

func _input(event) -> void:
	if timer_input.is_stopped() or timer_input.time_left > 0.0:
		if event.is_action_pressed("h"):
			key_input += "h"
		if event.is_action_pressed("a"):
			key_input += "a"
		if event.is_action_pressed("y"):
			key_input += "y"
		if event.is_action_pressed("n"):
			key_input += "n"
		
		timer_input.start(3)
		
		if key_input == "hayyan":
			activate_cheat()
			input_timeout()

func input_timeout() -> void:
	key_input = ""
	timer_input.stop()

func activate_cheat() -> void:
	isCheating = !isCheating
	if isCheating:
		player.show_notification("Cheat Activated!")
	else:
		player.show_notification("Cheat Deactivated!")

func _process(delta) -> void:
	if isCheating and root.isStarting == 2:
		search_target(delta)

func search_target(delta) -> void:
	if target == -1:
		randomize()
		target = int(round(rand_range(0, target_group.get_child_count() - 1)))
	
	# Move crosshair to target instant
	# player.look_at(target_group.get_child(target).global_transform.origin, Vector3.UP)
	
	# Move crosshair to target smoothly
	var target_pos = player.camera.global_transform.looking_at(
		target_group.get_child(target).global_transform.origin, Vector3.UP)
	
	player.camera.global_transform.basis.y = lerp(
		player.camera.global_transform.basis.y, target_pos.basis.y, delta * MOUSE_SPEED)
	player.camera.global_transform.basis.x = lerp(
		player.camera.global_transform.basis.x, target_pos.basis.x, delta * MOUSE_SPEED)
	player.camera.global_transform.basis.z = lerp(
		player.camera.global_transform.basis.z, target_pos.basis.z, delta * MOUSE_SPEED)
	
	# Shoot/fire
	var calc_x_x : bool = abs(player.camera.global_transform.basis.x.abs().x - target_pos.basis.x.abs().x) < 0.001
	var calc_x_y : bool = abs(player.camera.global_transform.basis.x.abs().y - target_pos.basis.x.abs().y) < 0.001
	var calc_x_z : bool = abs(player.camera.global_transform.basis.x.abs().z - target_pos.basis.x.abs().z) < 0.001
	
	var calc_y_x : bool = abs(player.camera.global_transform.basis.y.abs().x - target_pos.basis.y.abs().x) < 0.001
	var calc_y_y : bool = abs(player.camera.global_transform.basis.y.abs().y - target_pos.basis.y.abs().y) < 0.001
	var calc_y_z : bool = abs(player.camera.global_transform.basis.y.abs().z - target_pos.basis.y.abs().z) < 0.001
	
	var calc_z_x : bool = abs(player.camera.global_transform.basis.z.abs().x - target_pos.basis.z.abs().x) < 0.001
	var calc_z_y : bool = abs(player.camera.global_transform.basis.z.abs().y - target_pos.basis.z.abs().y) < 0.001
	var calc_z_z : bool = abs(player.camera.global_transform.basis.z.abs().z - target_pos.basis.z.abs().z) < 0.001
	
	var cursor_on_target : bool = (calc_x_x and calc_x_y and calc_x_z and
		calc_y_x and calc_y_y and calc_y_z and calc_z_x and calc_z_y and calc_z_z)
	
	if cursor_on_target or player.camera.global_transform.basis.is_equal_approx(target_pos.basis, 1e-02):
		Input.action_press("left_click")
		yield(get_tree().create_timer(1.3), "timeout")
		target = -1
