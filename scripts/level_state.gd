extends Node

var score = 0
@onready var label_score: Label = $LabelScore
@onready var timer: Timer = $Timer

enum garbage_types{ORGANIC,PLASTIC}
var fall_speed = 0.3
var old_fall_speed = 0
var item_counter = 0
var correct_sorted = 0
var correct_score = 200
var streak = 3
var streak_score = 300
var streak_count = 0
var reset_pos = Vector2(-3.0,-399.0)

signal slowdown

func _ready():
	$OrganicCan.garbage_type = garbage_types.ORGANIC
	$OrganicCan.animated_sprite.play("Organic")
	$PlasticCan.garbage_type = garbage_types.PLASTIC
	$PlasticCan.animated_sprite.play("Plastic")
	
	slowdown.connect(_activated_slowdown)

func _activated_slowdown() -> void:
	print("test start")
	old_fall_speed = fall_speed
	fall_speed = 0.1
	timer.start()
	

func _process(delta: float) -> void:		
	if (item_counter % 10) == 0 and item_counter != 0:
		fall_speed += 0.003 

func add_score():	
	if streak_count >= streak:
		score += streak_score
	else:
		score += correct_score
		
	streak_count += 1
	correct_sorted += 1
			
	label_score.text = "Score: " + str(score)
	print(streak_count)
	
func reset_streak():
	streak_count = 0	
	print("reset")
	


func _on_timer_timeout() -> void:
	print("TEST TIMER")
	timer.stop()
	fall_speed = old_fall_speed
	
