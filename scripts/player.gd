extends CharacterBody2D


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var preview_sprite: AnimatedSprite2D = %Preview

@onready var level_state: Node = %LevelState

@onready var ray_cast_down: RayCast2D = $RayCastDown

var garbage_type

var showMode: bool = false

var garbage

#Valid x-coordinates that the player can moce to. Initial value is only for testing (level manager overwrites this)
var xPositions: Array 

#These Vairables encode whether the player is currently moving and where he is trying to move to. (seperated by axis)
var movingSide = false
var movingDown = false
var sideTarget = 0
var downTarget = 0

#movement speed for the 2 axis (moveSpeedDown does not include gravity)
var moveSpeedSide = 2000
var moveSpeedDown = 3000

signal levelFinished

func start_spawning():
	new_item()
	

func _ready():
	if preview_sprite != null:
		preview_sprite.sprite_frames = animated_sprite.sprite_frames
		
	
func _physics_process(delta: float) -> void:
	if not showMode:
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
	#print(level_state.trashKeyList)
	var new_key = level_state.trashKeyList[0]
	var new_type = level_state.garbage[new_key]
	if level_state.trashKeyList.size() > 1:
		var prev_key = level_state.trashKeyList[1]
		preview_sprite.visible = true
		preview_sprite.play(prev_key)
	else:
		preview_sprite.visible = false
	animated_sprite.play(new_key)
	garbage_type = new_type
	print(garbage_type)
	level_state.trashKeyList.remove_at(0)
			
				
#calls the selection of a random new item and then spawns it at the reset_pos and resets its velocity			
func respawn():
	movingSide = false
	movingDown = false
	global_position = level_state.reset_pos
	velocity.y = 0
	if level_state.trashKeyList.size()==0:
		showMode = true
		var timer := Timer.new()
		timer.wait_time = 2.0  
		timer.one_shot = true
		add_child(timer)
		timer.start()
		await timer.timeout
		timer.queue_free()
		level_state.level_finished.emit(level_state.star_count);
		queue_free()
	else:
		new_item()

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
		
			
		
	
