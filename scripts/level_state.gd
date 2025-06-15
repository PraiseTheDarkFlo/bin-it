extends Node

@onready var timer: Timer = $Timer
@onready var score_text: HBoxContainer = $Score
@onready var multiplier_text: HBoxContainer = $Multiplier
@onready var stars: HBoxContainer = $Stars
@onready var power_ups: Node = %PowerUps
@onready var camera_2d: Camera2D = $"../Camera2D"
@onready var red_flash: ColorRect = $RedFlash

@onready var correct_sort_sound: AudioStreamPlayer = $correctlySorted
@onready var wrong_sort_sound: AudioStreamPlayer = $wronglySorted

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
var reset_pos = Vector2(576.0,-72.0)
var star_thresholds := [1000, 5000, 8000]
var star_count: int = 0

var multiplier: float = 1.0

var trashCanHeight = 100
var trashCanPositions = [276,476,676,876]

var speed_modifier: float = 1.0

var power_ups_on: bool = false
var negative_power_ups_on: bool = false

var level_started = false

var original_scale = null
var original_color = null
var original_position = null
	
signal slowdown
signal increase_score_powerup
signal halve_score_powerup
signal speedup

var trashDistribution = [2,2,2,2] #determines how many pieces of trash from each category will appear. The order is : [paper,yellow,rest,bio]
var deterministicFirstTrash = true
var firstTrash = garbage_types.BIO #determines the type of the very first piece of trash (only if previous variable is true)
var trashKeyList #stores in what order trash will fall during the level. Automatically filled when the level generates

signal level_finished(stars: int)

#The diffrent kindes of items which the player can be.
#The name string must equal the sprite that is used for the player!
#Followed by the type of garbage the item is. 
var garbage = {
	"Box": garbage_types.PAPER,
	"Flyer": garbage_types.PAPER,		
	"Magazine": garbage_types.PAPER,		
	"Paper_ball": garbage_types.PAPER,		
	"Sheet_of_paper": garbage_types.PAPER,
	"Papier_rollen": garbage_types.PAPER,
	"Nudeln": garbage_types.PAPER,
	"Folie": garbage_types.YELLOW,
	"Tube": garbage_types.YELLOW,
	"Milk": garbage_types.YELLOW,
	"Gifflar": garbage_types.YELLOW,
	"Mozzarella": garbage_types.YELLOW,
	"Tesa": garbage_types.YELLOW,
	"Dose": garbage_types.YELLOW,
	"Backpapier": garbage_types.REST,
	"Bong": garbage_types.REST,
	"Ordner": garbage_types.REST,
	"Picture": garbage_types.REST,
	"Zigarette": garbage_types.REST,
	"Scherben": garbage_types.REST,
	"Stifte": garbage_types.REST,
	"Apple": garbage_types.BIO,
	"Banana": garbage_types.BIO,
	"Leafs": garbage_types.BIO,
	"Loewenzahn": garbage_types.BIO,
	"Stick": garbage_types.BIO,
	"Sticks": garbage_types.BIO,
	"Straw": garbage_types.BIO,
}

#debug
func _ready():
	if correct_sort_sound:
		print("CorrectlySorted AudioStreamPlayer found!")
	else:
		print("ERROR: CorrectlySorted AudioStreamPlayer NOT found (check path and unique name if used).")
	
	if wrong_sort_sound:
		print("wronglySorted AudioStreamPlayer found!")
	else:
		print("ERROR: wronglySorted AudioStreamPlayer NOT found (check path and unique name if used).")


func start_level():
	trashKeyList=generateTrash()
	power_ups.xPositions=trashCanPositions
	level_started = true
	$PaperCan.garbage_type = garbage_types.PAPER
	$PaperCan.animated_sprite.play("Paper")
	$PlasticCan.garbage_type = garbage_types.YELLOW
	$PlasticCan.animated_sprite.play("Yellow")
	$RestCan.garbage_type = garbage_types.REST
	$RestCan.animated_sprite.play("Rest")
	$BioCan.garbage_type = garbage_types.BIO
	$BioCan.animated_sprite.play("Bio")
	power_ups.init_xPositionsOccupied()
	
	#connect the function _activated_slowdown to the signal slowdown
	slowdown.connect(_activated_slowdown)
	speedup.connect(_activated_speedup)
	increase_score_powerup.connect(_activated_increase_score) 
	halve_score_powerup.connect(_activated_half_score) 
	
	
#returns a dictionary, filtered by value
func filter_dict_by_value(dict, target_value):
	var result = {}
	for key in dict.keys():
		if dict[key] == target_value:
			result[key] = dict[key]
	return result
	
#returns a random key of the dictionary
func random_dict_key(dict):
	var random = randi_range(0,dict.size()-1)
	var keys = dict.keys()
	return keys[random] 
	
func swap(i : int, j : int, a : Array) -> Array:
	var t = a[i]
	a[i] = a[j]
	a[j] = t
	return a
	
func pushKeyToFront(keyArr, dict, value):
	var targetIndex=0 
	for i in range(keyArr.size()):
		var currentKey=keyArr[i]
		var currentValue=dict[currentKey]
		if currentValue==value:
			targetIndex=i
			break
	var result=swap(0,targetIndex,keyArr)
	return result
			
func generateTrash():
	var trashListResult=[] 
	var validDict={}
	for i in range(trashDistribution[0]): #paper
		validDict=filter_dict_by_value(garbage,garbage_types.PAPER)
		trashListResult.append(random_dict_key(validDict))
	for i in range(trashDistribution[1]): #plastic
		validDict=filter_dict_by_value(garbage,garbage_types.YELLOW)
		trashListResult.append(random_dict_key(validDict))
	for i in range(trashDistribution[2]): #rest
		validDict=filter_dict_by_value(garbage,garbage_types.REST)
		trashListResult.append(random_dict_key(validDict))
	for i in range(trashDistribution[3]): #bio
		validDict=filter_dict_by_value(garbage,garbage_types.BIO)
		trashListResult.append(random_dict_key(validDict))
		
	trashListResult.shuffle()
	
	if deterministicFirstTrash:
		trashListResult=pushKeyToFront(trashListResult,garbage,firstTrash)
		
	return trashListResult

#methode which handels the slowdown effect
func _activated_slowdown() -> void:
	print("slowdown activated!")
	old_fall_speed = fall_speed
	speed_modifier = 0.2
	timer.start()

func _activated_speedup():
	print("speedup activated!")
	old_fall_speed = fall_speed
	speed_modifier = 1.5
	timer.start()
	
func _activated_streak():
	streak+=4


func _play_increase_score_effect(): # Visual for power-up that increases score
	if not score_text:
		return

	var tween = get_tree().create_tween()
	
	if original_scale == null:
		original_scale = score_text.scale # Get actual current scale of score_text
	if original_color == null:
		original_color = score_text.modulate

	score_text.is_tweening = true 
	
	# Change color to gold
	tween.tween_property(
		score_text, "modulate", Color("ffd700"), 0.1 # Gold color
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	# Enlarge number 
	tween.tween_property(
		score_text, "scale", original_scale * 1.1, 0.15 # Scale to 1.5x its current size
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	# Back to original size
	tween.tween_property(
		score_text, "scale", original_scale, 0.25
	).set_delay(0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	# Change color back to original
	tween.tween_property(
		score_text, "modulate", original_color, 0.4
	).set_delay(0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


	# Reset the is_tweening flag when the tween finishes
	tween.finished.connect(tween_finish)


func _play_half_points_effect(): # Visual for power-up that halves score
	if not score_text:
		return
		
	var tween = get_tree().create_tween()

	if original_position == null:
		original_position = score_text.position
	if original_scale == null:
		original_scale = score_text.scale # Get actual current scale of score_text
	if original_color == null:
		original_color = score_text.modulate

	var shake_amount = 10

	score_text.is_tweening = true # Tell score.gd to pause updates (Crucial!)
	
	# Change color to red
	tween.tween_property(score_text, "modulate", Color("ff4444"), 0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	# Shake animation sequence:
	tween.tween_property(score_text, "position", original_position + Vector2(-shake_amount, 0), 0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(score_text, "position", original_position + Vector2(shake_amount, 0), 0.05).set_delay(0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(score_text, "position", original_position + Vector2(-shake_amount / 2, 0), 0.05).set_delay(0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(score_text, "position", original_position + Vector2(shake_amount / 2, 0), 0.05).set_delay(0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(score_text, "position", original_position, 0.1).set_delay(0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# Back to original color
	tween.tween_property(score_text, "modulate", original_color, 0.4).set_delay(0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	# Reset the is_tweening flag when the tween finishes
	tween.finished.connect(tween_finish)

func tween_finish() -> void:
	score_text.is_tweening = false
	original_position = null
	original_scale = null
	original_color = null
	
#double current streak	
func _activated_increase_score():
	score = score * 1.2
	check_stars(score)
	_play_increase_score_effect()

	
# Shalves current streak
func _activated_half_score():
	score = int(score / 2)
	check_stars(score)
	_play_half_points_effect()
	

	
#called every frame i think
func _process(delta: float) -> void:		
	
	multiplier = 1+(0.05*streak)
	fall_speed=base_fall_speed*multiplier*speed_modifier
	
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
	correct_sort_sound.play()
	
#methode which resets the streak	
func reset_streak():
	streak = 0	
	wrong_sort_sound.play()
	

#timer that handels when the slow effect should stop
func _on_timer_timeout() -> void:
	timer.stop()
	speed_modifier = 1.0
	print("Speed modifier reset to og")
	

func check_stars(score: int):
	var count_stars = 0
	for threshold in star_thresholds:
		if score >= threshold:
			count_stars += 1
	star_count = count_stars		
	stars.set_stars(star_count)	
	
func set_up_level(level:int, trash_count:int):
	match level:
		1:
			power_ups_on = false
			negative_power_ups_on = false
			firstTrash = garbage_types.PAPER
			trashCanPositions = [426,726]
			$PaperCan.global_position.x=trashCanPositions[0]
			$PlasticCan.global_position.x=trashCanPositions[1]
			trashDistribution = [trash_count,trash_count,0,0]
		2:	
			power_ups_on = true
			negative_power_ups_on = false
			firstTrash = garbage_types.BIO
			trashCanPositions = [376,576,776]
			$PaperCan.global_position.x=trashCanPositions[0]
			$PlasticCan.global_position.x=trashCanPositions[1]
			$BioCan.global_position.x=trashCanPositions[2]
			trashDistribution = [trash_count,trash_count,0,trash_count]
		3:
			power_ups_on = true
			negative_power_ups_on = true
			firstTrash = garbage_types.REST
			trashCanPositions = [276,476,676,876]
			$PaperCan.global_position.x=trashCanPositions[0]
			$PlasticCan.global_position.x=trashCanPositions[1]
			$BioCan.global_position.x=trashCanPositions[2]
			$RestCan.global_position.x=trashCanPositions[3]
			trashDistribution = [trash_count,trash_count,trash_count,trash_count]
	start_level()		
	$Player.xPositions=trashCanPositions
	$Player.start_spawning()

func paperParticles():
	$PaperCan.feedback()      
func yellowParticles():    
	$PlasticCan.feedback()      
func restParticles():    
	$RestCan.feedback()
func bioParticles():    
	$BioCan.feedback()
	
var shake_amount := 6
var shake_time := 0.2

func shake_screen():
	var time_passed := 0.0
	while time_passed < shake_time:
		var offset = Vector2(
			randf_range(-shake_amount, shake_amount),
			randf_range(-shake_amount, shake_amount)
		)
		camera_2d.offset = offset
		await get_tree().create_timer(0.02).timeout
		time_passed += 0.02
	camera_2d.offset = Vector2.ZERO
	
func flash_background():
	red_flash.visible = true
	red_flash.modulate = Color(1, 0, 0, 0.25) 
	await get_tree().create_timer(0.15).timeout
	red_flash.visible = false	
