extends Area2D

@onready var level_state: Node = %LevelState

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

@onready var power_ups: Node = $".."

#name of the powerup
var effect: String = ""

#var to store animation name from power_ups
var  initial_animation_name: String = ""

func _ready():
	$Timer.start()
	if initial_animation_name != "":
		if animated_sprite != null: #safety check
			animated_sprite.modulate.a = 0.0  
			animated_sprite.play(initial_animation_name)
			if initial_animation_name == "multiplierDown" or initial_animation_name == "speedup":
				# tint it red
				animated_sprite.modulate = Color(1.0, 0.6, 0.6, 0.8) 
			
			var tween = create_tween()
			tween.tween_property(animated_sprite, "modulate:a", 1.0, 0.5)	
			

func change_sprite(new_sprite_name: String) -> void:
	#for changing sprite later if needed
	if new_sprite_name != "":
		if animated_sprite != null:
			animated_sprite.play(new_sprite_name)
	
#handels the call of the function of the action if the player enters the powerup
func _on_body_entered(body: Node2D) -> void:
	if effect != "":
		var action = power_ups.get_action(effect)
		if action.is_valid():
			action.call()	
			power_ups.xPositionsOccupied[int(position.x)] = false
	queue_free()
	
	
	


func _on_timer_timeout() -> void:
	power_ups.xPositionsOccupied[int(position.x)] = false
	var tween = create_tween()
	tween.tween_property(animated_sprite, "modulate:a", 0.0, 0.5)
	
	tween.connect("finished", Callable(self, "_on_fade_complete"))
	
func _on_fade_complete():
	queue_free()
