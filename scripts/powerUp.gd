extends Area2D

@onready var level_state: Node = %LevelState

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var power_ups: Node = $".."

var effect: String = ""

func _on_body_entered(body: Node2D) -> void:
	if effect != "":
		var action = power_ups.get_action(effect)
		if action.is_valid():
			print("called")
			action.call()	
	queue_free()

func change_sprite(new_sprite) -> void:
	if new_sprite != null:
		animated_sprite.play(new_sprite)
		
