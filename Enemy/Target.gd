extends CSGMesh


const MIN_MAX_X : int = 25
const MIN_Y : int = -2
const MAX_Y : int = 10
const Z : int = -25


func _ready() -> void:
	randomize_position()

func randomize_position() -> void:
	randomize()
	var x : float = rand_range(-MIN_MAX_X, MIN_MAX_X)
	var y : float = rand_range(MIN_Y, MAX_Y)
	var random_coord : Vector3 = Vector3(x, y, Z)
	global_transform.origin = random_coord

func get_size() -> float:
	return scale.x

func set_size(target_size) -> void:
	# 0.1 - 2, default 1
	scale = Vector3(target_size, target_size, target_size)

func get_color() -> Color:
	return mesh.surface_get_material(0).albedo_color

func set_color(color) -> void:
	mesh.surface_get_material(0).albedo_color = color
