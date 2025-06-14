extends Button
@onready var game_state = get_node("/root/Game/GameState")  

func _on_pressed() -> void:
	get_tree().paused = false
	game_state.stop_level()
	get_parent().queue_free()
	game_state.current_level = -1;
	game_state.reset_overview()
	game_state.showLevelSelect();
