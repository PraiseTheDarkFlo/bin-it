extends CharacterBody2D


const SPEED: float  = 200.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var level_state: Node = $".."

var garbage_type

var garbage

func _ready():
	garbage = {
		"Banana": level_state.garbage_types.ORGANIC,
		"Bottle": level_state.garbage_types.PLASTIC,
	}
	new_item()
	
	
func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta * level_state.fall_speed
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Input.is_action_just_pressed("down"):
		velocity.y *=2
	elif Input.is_action_just_released("down"):
		velocity.y /=2
		
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED +200
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func new_item():
	if (garbage != null):
		var random = randi_range(0,garbage.size()-1)
		var keys = garbage.keys()
		var random_key = keys[random]
		var random_type = garbage[random_key]
		
		animated_sprite.play(random_key)
		garbage_type = random_type
			
func respawn():
	new_item()
	global_position = level_state.reset_pos
	velocity.y = 0
	
