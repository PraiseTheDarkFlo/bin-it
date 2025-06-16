extends Node2D  



func _process(delta):
	if Input.is_action_just_pressed("start"):
		get_tree().paused = false
		queue_free()


func _on_ready() -> void:
	get_tree().paused = true
