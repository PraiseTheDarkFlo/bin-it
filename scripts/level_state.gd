extends Node

@onready var timer: Timer = $Timer
@onready var score_text: HBoxContainer = $Score
@onready var multiplier_text: HBoxContainer = $Multiplier
@onready var stars: HBoxContainer = $Stars


#enum for the different garbage types is used for the trashcans and for the items to check if they are qual types
enum garbage_types{PAPER,YELLOW,REST,BIO}

var base_fall_speed = 300
var fall_speed = 300
var old_fall_speed = 0
var item_counter = 0
var score = 0
var correct_sorted = 0
var correct_score = 100
var streak = 0
var reset_pos = Vector2(-3.0,-399.0)
var star_thresholds := [1000, 5000, 8000]
var star_count: int = 0

var multiplier: float = 1.0

var trashCanHeight = 100
var trashCanPositions = [-300,-100, 100,300]

signal slowdown
signal streak_up

signal level_finished(stars: int) #TODO Emit on level finish

func _ready():
	#init the diffrent garbagecans with their type and sprite
	$PaperCan.garbage_type = garbage_types.PAPER
	$PaperCan.animated_sprite.play("Paper")
	$PaperCan.global_position.x=trashCanPositions[0]
	$PlasticCan.garbage_type = garbage_types.YELLOW
	$PlasticCan.global_position.x=trashCanPositions[1]
	$PlasticCan.animated_sprite.play("Yellow")
	$RestCan.garbage_type = garbage_types.REST
	$RestCan.global_position.x=trashCanPositions[2]
	$RestCan.animated_sprite.play("Rest")
	$BioCan.garbage_type = garbage_types.BIO
	$BioCan.global_position.x=trashCanPositions[3]
	$BioCan.animated_sprite.play("Bio")
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
	
	score_text.update_score(score)
	
	multiplier_text.update_mul(multiplier)
	
	if (item_counter % 10) == 0 and item_counter != 0:
		fall_speed += 0.003 

#adds the right score fore a right sorted item
func add_score():	
	score+=int(correct_score*multiplier)
	
	check_stars(score)
	streak += 1
	correct_sorted += 1
	
	
#methode which resets the streak	
func reset_streak():
	streak = 0	
	

#timer that handels when the slow effect should stop
func _on_timer_timeout() -> void:
	timer.stop()
	fall_speed = old_fall_speed
	

#temporary method to fake the end of an level
func _on_tmp_finish_button_pressed() -> void:
	level_finished.emit(star_count);

func check_stars(score: int):
	var count_stars = 0
	for threshold in star_thresholds:
		if score >= threshold:
			count_stars += 1
	star_count = count_stars		
	stars.set_stars(star_count)		
