extends Node

@onready var label_score: Label = $LabelScore
@onready var timer: Timer = $Timer
@onready var label_multiplier: Label = $LabelMultiplier


#enum for the different garbage types is used for the trashcans and for the items to check if they are qual types
enum garbage_types{ORGANIC,PLASTIC}

var base_fall_speed = 300
var fall_speed = 300
var old_fall_speed = 0
var item_counter = 0
var score = 0
var correct_sorted = 0
var correct_score = 100
#var streak_score = 100
var streak = 0
var reset_pos = Vector2(-3.0,-399.0)

var multiplier = 1

var trashCanHeight = 100
var trashCanPositions = [-100, 100]

signal slowdown
signal streak_up

func _ready():
	#init the diffrent garbagecans with their type and sprite
	$OrganicCan.garbage_type = garbage_types.ORGANIC
	$OrganicCan.animated_sprite.play("Organic")
	$OrganicCan.global_position.x=trashCanPositions[0]
	$PlasticCan.garbage_type = garbage_types.PLASTIC
	$PlasticCan.global_position.x=trashCanPositions[1]
	$PlasticCan.animated_sprite.play("Plastic")
	#$PlasticCan.animated_sprite.play("coin")
	$Player.xPositions=trashCanPositions
	$PowerUps.xPositions=trashCanPositions
	
	
	
	#connect the function _activated_slowdown to the signal slowdown
	slowdown.connect(_activated_slowdown)
	streak_up.connect(_activated_streak)


#methode which handels the slowdown effect
func _activated_slowdown() -> void:
	print("test start")
	old_fall_speed = fall_speed
	fall_speed = 0.1
	timer.start()
	
func _activated_streak():
	streak+=4
	
#called every frame i think
func _process(delta: float) -> void:		
	
	multiplier = 1+(0.05*streak)
	fall_speed=base_fall_speed*multiplier
	
	label_score.text = "Score: " + str(score)
	label_multiplier.text = "Multiplier: x" + str(multiplier)
	
	if (item_counter % 10) == 0 and item_counter != 0:
		fall_speed += 0.003 

#adds the right score fore a right sorted item
func add_score():	
	score+=int(correct_score*multiplier)
		
	streak += 1
	correct_sorted += 1
	
	
#methode which resets the streak	
func reset_streak():
	streak = 0	
	

#timer that handels when the slow effect should stop
func _on_timer_timeout() -> void:
	timer.stop()
	fall_speed = old_fall_speed
	
