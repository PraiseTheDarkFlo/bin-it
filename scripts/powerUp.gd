extends Area2D

@onready var level_state: Node = %LevelState

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var power_ups: Node = $".."

#name of the powerup
var effect: String = ""

#var to store animation name from power_ups
var  initial_animation_name: String = ""

func _ready():
	if initial_animation_name != "":
		if animated_sprite != null: #safety check
			animated_sprite.play(initial_animation_name)
			if initial_animation_name == "multiplierDown" or initial_animation_name == "speedup":
				# tint it red
				animated_sprite.modulate = Color(1.0, 0.6, 0.6, 0.8) 
		else:
			print("AnimatedSprite2D is null ")
			
			

func change_sprite(new_sprite_name: String) -> void:
	#for changing sprite later if needed
	if new_sprite_name != "":
		if animated_sprite != null:
			animated_sprite.play(new_sprite_name)
		else:
			print("Warning: Attempted to change sprite on null animated_sprite for PowerUp")

#handels the call of the function of the action if the player enters the powerup
func _on_body_entered(body: Node2D) -> void:
	if effect != "":
		var action = power_ups.get_action(effect)
		if action.is_valid():
			print("called")
			action.call()	
	queue_free()
