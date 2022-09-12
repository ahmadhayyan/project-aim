extends Node


const FILEPATH : String = "user://data.json"
var score : int = 0
var accuracy : float = 0.0
var kps : float = 0.0
var avg_ttk : String = "-"


func _ready() -> void:
	if read_data() == false:
		write_data()

func write_data() -> void:
	var data := {
		"score": score,
		"accuracy": accuracy,
		"kps": kps,
		"avg_ttk": avg_ttk
	}
	
	var file : File = File.new()
	if file.open(FILEPATH, file.WRITE) == OK:
		var json := to_json(data)
		file.store_string(json)
		file.close()

func read_data() -> bool:
	var file : File = File.new()
	if file.open(FILEPATH, File.READ) == OK:
		var data : Dictionary = JSON.parse(file.get_as_text()).result
		file.close()
		
		score = data.score
		accuracy = data.accuracy
		kps = data.kps
		avg_ttk = data.avg_ttk
		
		return true
	return false

func update_score(new_score, new_accuracy, new_kps, new_avg_ttk) -> void:
	score = new_score
	accuracy = new_accuracy
	kps = new_kps
	avg_ttk = new_avg_ttk
	
	write_data()
