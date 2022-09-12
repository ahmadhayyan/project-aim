extends Control


onready var hSlider_MouseSensitivity := $Control/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer7/HBoxContainer/HSlider_MouseSensitivity
onready var lineEdit_MouseSensitivity := $Control/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer7/HBoxContainer/LineEdit_MouseSensitivity

onready var hSlider_TargetSize := $Control/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer/HBoxContainer/HSlider_TargetSize
onready var lineEdit_TargetSize := $Control/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer/HBoxContainer/LineEdit_TargetSize
onready var colorPicker_Target := $Control/VBoxContainer/ScrollContainer/VBoxContainer/Container_Color2/ColorPickerButton_Target

onready var hSlider_MasterVolume := $Control/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer2/HBoxContainer/HSlider_MasterVolume
onready var lineEdit_MasterVolume := $Control/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer2/HBoxContainer/LineEdit_MasterVolume

onready var menuButton_WindowMode := $Control/VBoxContainer/ScrollContainer/VBoxContainer/Container_WindowMode/WindowMode
onready var hSlider_MaxFPS := $Control/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer8/HBoxContainer/HSlider_MaxFPS
onready var lineEdit_MaxFPS := $Control/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer8/HBoxContainer/LineEdit_MaxFPS

onready var hSlider_Crosshair_CenterWidth := $Control/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer3/HBoxContainer/HSlider_Crosshair_CenterWidth
onready var lineEdit_Crosshair_CenterWidth := $Control/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer3/HBoxContainer/LineEdit_Crosshair_CenterWidth
onready var hSlider_Crosshair_LineWidth := $Control/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer4/HBoxContainer/HSlider_Crosshair_LineWidth
onready var lineEdit_Crosshair_LineWidth := $Control/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer4/HBoxContainer/LineEdit_Crosshair_LineWidth
onready var hSlider_Crosshair_LineInnerGap := $Control/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer5/HBoxContainer/HSlider_Crosshair_LineInnerGap
onready var lineEdit_Crosshair_LineInnerGap := $Control/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer5/HBoxContainer/LineEdit_Crosshair_LineInnerGap
onready var hSlider_Crosshair_LineLength := $Control/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer6/HBoxContainer/HSlider_Crosshair_Length
onready var lineEdit_Crosshair_LineLength := $Control/VBoxContainer/ScrollContainer/VBoxContainer/HBoxContainer6/HBoxContainer/LineEdit_Crosshair_Length
onready var colorPicker_Crosshair := $Control/VBoxContainer/ScrollContainer/VBoxContainer/Container_Color/ColorPickerButton_Crosshair

onready var root : Spatial = get_parent().get_parent()
onready var player : KinematicBody = root.get_node("Player")

const FILEPATH : String = "user://settings.ini"
var configfile : ConfigFile = ConfigFile.new()


func _ready() -> void:
	read_config()

func read_config() -> void:
	if configfile.load(FILEPATH) == OK:
		hSlider_MouseSensitivity.value = configfile.get_value("gameplay", "mouse_sensitivity")
		hSlider_TargetSize.value = configfile.get_value("gameplay", "target_size")
		colorPicker_Target.color = configfile.get_value("gameplay", "target_color")
		_on_MenuButton_changed("WindowMode", configfile.get_value("video", "window_mode"))
		hSlider_MaxFPS.value = configfile.get_value("video", "max_fps")
		hSlider_MasterVolume.value = configfile.get_value("audio", "master_volume")
		hSlider_Crosshair_CenterWidth.value = configfile.get_value("crosshair", "center_width")
		hSlider_Crosshair_LineWidth.value = configfile.get_value("crosshair", "line_width")
		hSlider_Crosshair_LineInnerGap.value = configfile.get_value("crosshair", "line_inner_gap")
		hSlider_Crosshair_LineLength.value = configfile.get_value("crosshair", "line_length")
		colorPicker_Crosshair.color = configfile.get_value("crosshair", "color")

func _input(event) -> void:
	if event.is_action_pressed("ui_cancel"):
		save_and_close()

func _on_Button_ESC_pressed() -> void:
	save_and_close()

func _on_Button_Save_pressed() -> void:
	save_and_close()

func save_and_close() -> void:
	configfile.set_value("gameplay", "mouse_sensitivity", hSlider_MouseSensitivity.value)
	configfile.set_value("gameplay", "target_size", int(hSlider_TargetSize.value))
	configfile.set_value("gameplay", "target_color", colorPicker_Target.color)
	configfile.set_value("video", "window_mode", int(OS.window_fullscreen))
	configfile.set_value("video", "max_fps", int(hSlider_MaxFPS.value))
	configfile.set_value("audio", "master_volume", int(hSlider_MasterVolume.value))
	configfile.set_value("crosshair", "center_width", int(hSlider_Crosshair_CenterWidth.value))
	configfile.set_value("crosshair", "line_width", int(hSlider_Crosshair_LineWidth.value))
	configfile.set_value("crosshair", "line_inner_gap", int(hSlider_Crosshair_LineInnerGap.value))
	configfile.set_value("crosshair", "line_length", int(hSlider_Crosshair_LineLength.value))
	configfile.set_value("crosshair", "color", colorPicker_Crosshair.color)
	if configfile.save(FILEPATH) != OK:
		print("[ERROR][Settings] Failed to save settings.")
	queue_free()

# Mouse Sensitivity ------------------------------------------------------------
func _on_LineEdit_MouseSensitivity_text_changed(new_text) -> void:
	hSlider_MouseSensitivity.value = float(new_text)
	lineEdit_MouseSensitivity.caret_position = lineEdit_MouseSensitivity.max_length

func _on_HSlider_MouseSensitivity_value_changed(value) -> void:
	lineEdit_MouseSensitivity.text = str(value)
	player.look_sensitivity = (value / 10)


# Target -----------------------------------------------------------------------
func _on_LineEdit_TargetSize_text_changed(new_text) -> void:
	hSlider_TargetSize.value = int(new_text)
	lineEdit_TargetSize.caret_position = lineEdit_TargetSize.max_length

func _on_HSlider_TargetSize_value_changed(value) -> void:
	lineEdit_TargetSize.text = str(value)
	for i in range(3):
		root.target_group.get_child(i).set_size(value * 0.1)

func _on_ColorPickerButton_Target_color_changed(color) -> void:
	for i in range(3):
		root.target_group.get_child(i).set_color(color)


# Video ------------------------------------------------------------------------
func _on_MenuButton_changed(menu, value) -> void:
	if menu == "WindowMode":
		menuButton_WindowMode.text = menuButton_WindowMode.get_popup().get_item_text(value)
		OS.window_fullscreen = bool(value)

func _on_LineEdit_MaxFPS_text_changed(new_text) -> void:
	hSlider_MaxFPS.value = int(new_text)
	lineEdit_MaxFPS.caret_position = lineEdit_MaxFPS.max_length

func _on_HSlider_MaxFPS_value_changed(value) -> void:
	lineEdit_MaxFPS.text = str(value)
	Engine.set_target_fps(value)


# Audio ------------------------------------------------------------------------
func _on_LineEdit_MasterVolume_text_changed(new_text) -> void:
	hSlider_MasterVolume.value = int(new_text)
	lineEdit_MasterVolume.caret_position = lineEdit_MasterVolume.max_length

func _on_HSlider_MasterVolume_value_changed(value) -> void:
	lineEdit_MasterVolume.text = str(value)
	value = round(-60 - ((value * -60) / 100))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)


# Crosshair --------------------------------------------------------------------
func _on_LineEdit_Crosshair_CenterWidth_text_changed(new_text) -> void:
	hSlider_Crosshair_CenterWidth.value = int(new_text)
	lineEdit_Crosshair_CenterWidth.caret_position = lineEdit_Crosshair_CenterWidth.max_length

func _on_HSlider_Crosshair_CenterWidth_value_changed(value) -> void:
	lineEdit_Crosshair_CenterWidth.text = str(value)
	player.crosshair.get_node("Dot/Center").width = value

func _on_LineEdit_Crosshair_LineWidth_text_changed(new_text) -> void:
	hSlider_Crosshair_LineWidth.value = int(new_text)
	lineEdit_Crosshair_LineWidth.caret_position = lineEdit_Crosshair_LineWidth.max_length

func _on_HSlider_Crosshair_LineWidth_value_changed(value) -> void:
	lineEdit_Crosshair_LineWidth.text = str(value)
	player.crosshair.get_node("Lines/Right").width = value
	player.crosshair.get_node("Lines/Bottom").width = value
	player.crosshair.get_node("Lines/Left").width = value
	player.crosshair.get_node("Lines/Top").width = value

func _on_LineEdit_Crosshair_LineInnerGap_text_changed(new_text) -> void:
	hSlider_Crosshair_LineInnerGap.value = int(new_text)
	lineEdit_Crosshair_LineInnerGap.caret_position = lineEdit_Crosshair_LineInnerGap.max_length

func _on_HSlider_Crosshair_LineInnerGap_value_changed(value) -> void:
	lineEdit_Crosshair_LineInnerGap.text = str(value)
	player.crosshair.get_node("Lines/Right").set_point_position(0, Vector2(value, 0))
	player.crosshair.get_node("Lines/Bottom").set_point_position(0, Vector2(value, 0))
	player.crosshair.get_node("Lines/Left").set_point_position(0, Vector2(value, 0))
	player.crosshair.get_node("Lines/Top").set_point_position(0, Vector2(value, 0))
	_on_HSlider_Crosshair_Length_value_changed(hSlider_Crosshair_LineLength.value)

func _on_LineEdit_Crosshair_Length_text_changed(new_text) -> void:
	hSlider_Crosshair_LineLength.value = int(new_text)
	lineEdit_Crosshair_LineLength.caret_position = lineEdit_Crosshair_LineLength.max_length

func _on_HSlider_Crosshair_Length_value_changed(value) -> void:
	lineEdit_Crosshair_LineLength.text = str(value)
	value += hSlider_Crosshair_LineInnerGap.value
	player.crosshair.get_node("Lines/Right").set_point_position(1, Vector2(value, 0))
	player.crosshair.get_node("Lines/Bottom").set_point_position(1, Vector2(value, 0))
	player.crosshair.get_node("Lines/Left").set_point_position(1, Vector2(value, 0))
	player.crosshair.get_node("Lines/Top").set_point_position(1, Vector2(value, 0))

func _on_ColorPickerButton_Crosshair_color_changed(color) -> void:
	player.crosshair.get_node("Dot/Center").default_color = color
	player.crosshair.get_node("Lines/Right").default_color = color
	player.crosshair.get_node("Lines/Bottom").default_color = color
	player.crosshair.get_node("Lines/Left").default_color = color
	player.crosshair.get_node("Lines/Top").default_color = color
