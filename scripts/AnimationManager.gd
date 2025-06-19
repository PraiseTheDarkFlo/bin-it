extends Node

#  to store references to AnimatedSprite2D nodes
var _animated_sprites = {} 

func _ready():
	# This loop will automatically register any AnimatedSprite2D nodes
	# that are placed in a group named "dialogue_characters" when the scene starts.
	# Make sure you add your AnimatedSprite2D nodes to this group!
	for node in get_tree().get_nodes_in_group("dialogue_characters"):
		if node is AnimatedSprite2D:
			_animated_sprites[node.name] = node
		else:
			push_warning("AnimationManager: Node '%s' in 'dialogue_characters' group is not an AnimatedSprite2D. Skipping." % node.name)


# Function to manually register an AnimatedSprite2D node with the manager
# This is called by your character's _ready() method if not in a group.
func register_animated_sprite(sprite_name: String, sprite_node: AnimatedSprite2D):
	_animated_sprites[sprite_name] = sprite_node


# Function to unregister a sprite (e.g., when it leaves the scene)
# This is called by your character's _exit_tree() method.
func unregister_animated_sprite(sprite_name: String):
	if _animated_sprites.has(sprite_name):
		_animated_sprites.erase(sprite_name)


# Function to play an animation on a specific AnimatedSprite2D
# 'sprite_name' could be "player" or "neighbour" (matching your node names)
# 'animation_name' would be "talking", "idle", etc.
func play_sprite_animation(sprite_name: String, animation_name: String):
	if _animated_sprites.has(sprite_name):
		var sprite = _animated_sprites[sprite_name]
		if sprite.has_animation(animation_name):
			sprite.play(animation_name)
		else:
			push_warning("AnimationManager: Animation '%s' not found for AnimatedSprite2D '%s'." % [animation_name, sprite_name])
	else:
		push_warning("AnimationManager: AnimatedSprite2D '%s' not registered." % sprite_name)


# Function to make an AnimatedSprite2D disappear (hide it)
func hide_sprite(sprite_name: String):
	if _animated_sprites.has(sprite_name):
		_animated_sprites[sprite_name].visible = false
	else:
		push_warning("AnimationManager: AnimatedSprite2D '%s' not registered to hide." % sprite_name)


# Function to make an AnimatedSprite2D appear (show it)
func show_sprite(sprite_name: String):
	if _animated_sprites.has(sprite_name):
		_animated_sprites[sprite_name].visible = true
	else:
		push_warning("AnimationManager: AnimatedSprite2D '%s' not registered to show." % sprite_name)
