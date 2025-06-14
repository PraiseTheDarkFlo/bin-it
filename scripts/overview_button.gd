extends Button

@onready var game_state = get_node("/root/Game/GameState")  

var overview = null

func _on_pressed() -> void:
	overview = preload("res://scenes/overview.tscn").instantiate()
	get_tree().current_scene.add_child(overview)
	overview.show_buttons()
	get_tree().paused = true
	
func press_without_buttons():
	overview = preload("res://scenes/overview.tscn").instantiate()
	get_tree().current_scene.add_child(overview)
	get_tree().paused = true
	
func resume():
	get_tree().paused = false
	overview.queue_free()
	overview = null
		
func _unhandled_input(event):
	if event.is_action_pressed("menu"):
		if overview:
			resume()
		else:
			if game_state.state == game_state.game_states.LEVEL_SELECT:
				press_without_buttons()
			else:
				$".".pressed.emit()
