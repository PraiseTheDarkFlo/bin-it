extends Button


func _on_pressed(level: int) -> void:
	self.get_parent().level_selected.emit(level);
