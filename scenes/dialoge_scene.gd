extends Node2D

@onready var level_00: TextureRect = $Level00
@onready var level_01: TextureRect = $Level01

var backgrounds = {}  

func _ready():
	backgrounds = {
		0: level_00,
		1: level_01,
		2: null,
		3: null,
	}
	
func set_background(level: int) -> void:
	if level in backgrounds.keys():
		for i in backgrounds.keys():
			if backgrounds[i] != null:
				backgrounds[i].visible = (i == level)
