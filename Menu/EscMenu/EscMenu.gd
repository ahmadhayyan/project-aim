extends Control


onready var lineEdit_Highscore_Score : LineEdit = $VBoxContainer/Panel_Highscore/VBoxContainer/HBoxContainer2/LineEdit_Score
onready var lineEdit_Highscore_Accuracy : LineEdit = $VBoxContainer/Panel_Highscore/VBoxContainer/HBoxContainer3/LineEdit_Accuracy
onready var lineEdit_Highscore_AvgTTK : LineEdit = $VBoxContainer/Panel_Highscore/VBoxContainer/HBoxContainer/LineEdit_AvgTTK
onready var panel_NewHighScore : Panel = $VBoxContainer/Panel_Highscore/Panel_NewHighscore

onready var panel_Score : Panel = $VBoxContainer/Panel_Highscore/Panel_Score
onready var lineEdit_Score : LineEdit = panel_Score.get_node("VBoxContainer/HBoxContainer2/LineEdit_Score")
onready var lineEdit_Accuracy : LineEdit = panel_Score.get_node("VBoxContainer/HBoxContainer3/LineEdit_Accuracy")
onready var lineEdit_KPS : LineEdit = panel_Score.get_node("VBoxContainer/HBoxContainer/LineEdit_KPS")
onready var lineEdit_AvgTTK : LineEdit = panel_Score.get_node("VBoxContainer/HBoxContainer4/LineEdit_AvgTTK")

onready var button_Return : Button = $VBoxContainer/Button_Return

onready var root : Spatial = get_parent()
onready var player : KinematicBody = root.get_node("Player")


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	update_best_score(Highscore.score, Highscore.accuracy, Highscore.kps, Highscore.avg_ttk)
	
	if root.isStarting == 3:
		button_Return.visible = false
		panel_Score.visible = true
		update_score(
			player.get_score(),
			player.get_accuracy(),
			player.get_kill_per_second(),
			player.get_avg_time_to_kill()
		)

func _input(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		if not has_node("Settings") and root.isStarting != 3:
			_on_Button_Return_pressed()

# Score ------------------------------------------------------------------------
func update_best_score(score, accuracy, kps, avg_ttk) -> void:
	if score > Highscore.score:
		panel_NewHighScore.visible = true
		Highscore.update_score(score, accuracy, kps, avg_ttk)
	
	lineEdit_Highscore_Score.text = str(score)
	lineEdit_Highscore_Accuracy.text = str(accuracy)
	lineEdit_Highscore_AvgTTK.text = str(avg_ttk)

func update_score(score, accuracy, kps, avg_ttk) -> void:
	lineEdit_Score.text = str(score)
	lineEdit_Accuracy.text = str(accuracy)
	lineEdit_KPS.text = str(kps)
	lineEdit_AvgTTK.text = str(avg_ttk)
	
	if player.get_score() > Highscore.score:
		update_best_score(score, accuracy, kps, avg_ttk)

# Buttons ----------------------------------------------------------------------
func _on_Button_Return_pressed() -> void:
	queue_free()
	root.get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_Button_Restart_pressed() -> void:
	root.startup()
	root.get_node("Player").startup()
	_on_Button_Return_pressed()

func _on_Button_Settings_pressed() -> void:
	var settings = load("res://Menu/Settings/Settings.tscn").instance()
	add_child(settings)

func _on_Button_Leave_pressed() -> void:
	get_tree().quit()
