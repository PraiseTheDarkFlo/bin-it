extends Area2D

@onready var level_state: Node = %LevelState

@onready var player: CharacterBody2D = $"../Player"

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var particles = $FeedbackParticles

var garbage_type

signal paperParticles
signal yellowParticles
signal restParticles
signal bioParticles


#methode which handels when the player enters the trashcan
func _on_body_entered(body: Node2D) -> void:
	if garbage_type == player.garbage_type:
		level_state.add_score()	
	else:
		if player.garbage_type==level_state.garbage_types.PAPER:
			level_state.paperParticles()
		if player.garbage_type==level_state.garbage_types.YELLOW:
			level_state.yellowParticles()
		if player.garbage_type==level_state.garbage_types.REST:
			level_state.restParticles()
		if player.garbage_type==level_state.garbage_types.BIO:
			level_state.bioParticles()
		level_state.reset_streak()
		
	level_state.item_counter += 1
	body.respawn()
	
func feedback():
	level_state.shake_screen()
	level_state.flash_background()
	particles.emitting = false  # Reset in case it's mid-effect
	particles.restart()
	particles.emitting = true
	
