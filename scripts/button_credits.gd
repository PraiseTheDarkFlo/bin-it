extends Button


func _on_pressed() -> void:
	self.get_parent().open_credits.emit();
