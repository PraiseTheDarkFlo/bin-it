extends Button

@onready var game_state = get_node("/root/Game/GameState")  


func _on_pressed() -> void:
	get_tree().paused = false
	game_state.reset_overview()
	get_parent().queue_free()
	
