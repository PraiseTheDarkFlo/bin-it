extends CharacterBody2D


#const SPEED: float  = 200.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var level_state: Node = %LevelState

@onready var ray_cast_down: RayCast2D = $RayCastDown

var garbage_type

var garbage

#Valid x-coordinates that the player can moce to. Initial value is only for testing (level manager overwrites this)
var xPositions = [-50,0,50]

#These Vairables encode whether the player is currently moving and where he is trying to move to. (seperated by axis)
var movingSide = false
var movingDown = false
var sideTarget = 0
var downTarget = 0

#movement speed for the 2 axis (moveSpeedDown does not include gravity)
var moveSpeedSide = 2000
var moveSpeedDown = 3000

func _ready():
	#The diffrent kindes of items which the player can be.
	#The name string must equal the sprite that is used for the player!
	#Followed by the type of garbage the item is. 
	garbage = {
		"Box": level_state.garbage_types.PAPER,
		"Flyer": level_state.garbage_types.PAPER,		
		"Magazine": level_state.garbage_types.PAPER,		
		"Paper_ball": level_state.garbage_types.PAPER,		
		"Sheet_of_paper": level_state.garbage_types.PAPER,
		"Papier_rollen": level_state.garbage_types.PAPER,
		"Nudeln": level_state.garbage_types.PAPER,
		"Folie": level_state.garbage_types.YELLOW,
		"Tube": level_state.garbage_types.YELLOW,
		"Milk": level_state.garbage_types.YELLOW,
		"Gifflar": level_state.garbage_types.YELLOW,
		"Mozzarella": level_state.garbage_types.YELLOW,
		"Tesa": level_state.garbage_types.YELLOW,
		"Dose": level_state.garbage_types.YELLOW,
		"Backpapier": level_state.garbage_types.REST,
		"Bong": level_state.garbage_types.REST,
		"Ordner": level_state.garbage_types.REST,
		"Picture": level_state.garbage_types.REST,
		"Zigarette": level_state.garbage_types.REST,
		"Scherben": level_state.garbage_types.REST,
		"Stifte": level_state.garbage_types.REST,
		"Apple": level_state.garbage_types.BIO,
		"Banana": level_state.garbage_types.BIO,
		"Leafs": level_state.garbage_types.BIO,
		"Loewenzahn": level_state.garbage_types.BIO,
		"Stick": level_state.garbage_types.BIO,
		"Sticks": level_state.garbage_types.BIO,
		"Straw": level_state.garbage_types.BIO,
	}
	new_item()
	
	
func _physics_process(delta: float) -> void:
	if !movingDown: #fast drop pauses gravity
		global_position.y += delta * level_state.fall_speed
	
	if Input.is_action_just_pressed("right"):
		if !movingDown:
			findClosestRight()
			movingSide=true
		
	if Input.is_action_just_pressed("left"):
		if !movingDown:
			findClosestLeft()
			movingSide=true	
		
	if Input.is_action_just_pressed("down"):
		if !movingSide:
			findClosestDown()
			movingDown=true
		
	go_there(delta)

#handels the selecting of new items randomly.
func new_item():
	if (garbage != null):
		#selects random an item of the dictionary
		var random = randi_range(0,garbage.size()-1)
		var keys = garbage.keys()
		var random_key = keys[random]
		var random_type = garbage[random_key]
		print(random_key)
		
		animated_sprite.play(random_key)
		garbage_type = random_type
			
#calls the selection of a random new item and then spawns it at the reset_pos and resets its velocity			
func respawn():
	new_item()
	global_position = level_state.reset_pos
	velocity.y = 0

#finds the closest valid (x-)position to the right of the current position	
func findClosestRight():
	sideTarget=global_position.x
	for x in xPositions:
		if x>global_position.x:
			if sideTarget==global_position.x:
				sideTarget=x
			elif x<sideTarget:
				sideTarget=x

	
#finds the closest valid (x-)position to the left of the current position	
func findClosestLeft():
	sideTarget=global_position.x
	for x in xPositions:
		if x<global_position.x:
			if sideTarget==global_position.x:
				sideTarget=x
			elif x>sideTarget:
				sideTarget=x

#casts a ray down to find nearest bin/power-up
func findClosestDown():
	downTarget=global_position.y
	if ray_cast_down.is_colliding():
		downTarget=ray_cast_down.get_collision_point().y
	print(downTarget)
	print(ray_cast_down.get_collider())

#moves player to target position (linear interpolation)
func go_there(delta):
	if movingDown:
		global_position.y=move_toward(global_position.y,downTarget,delta*moveSpeedDown)
		if global_position.y==downTarget:
			movingDown=false
	elif movingSide:
		global_position.x=move_toward(global_position.x,sideTarget,delta*moveSpeedSide)
		if global_position.x==sideTarget:
			movingSide=false
		
			
		
	
