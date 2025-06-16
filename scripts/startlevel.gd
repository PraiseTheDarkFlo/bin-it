extends Node2D  
@onready var game_state = get_node("/root/Game/GameState")  

func _process(delta):
	if Input.is_action_just_pressed("start"):
		get_tree().paused = false
		game_state.overlay = false
		queue_free()


func _on_ready() -> void:
	game_state.overlay = true
	get_tree().paused = true
