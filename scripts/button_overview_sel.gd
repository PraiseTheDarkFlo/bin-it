extends Button

@onready var game_state = get_node("/root/Game/GameState")  

func _on_pressed() -> void:
	var overview = preload("res://scenes/overview.tscn").instantiate()
	get_tree().current_scene.add_child(overview)
	get_tree().paused = true
	game_state.set_overview(overview)
