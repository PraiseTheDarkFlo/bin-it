extends Button

func _on_pressed() -> void:
	var overview = preload("res://scenes/overview.tscn").instantiate()
	get_tree().current_scene.add_child(overview)
	get_tree().paused = true
