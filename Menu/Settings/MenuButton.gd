extends MenuButton


func _ready() -> void:
	var popup : PopupMenu = get_popup()
	var _conn := popup.connect("id_pressed", self, "_on_item_pressed")

func _on_item_pressed(id) -> void:
	get_node("../../../../../../")._on_MenuButton_changed(self.name, id)
