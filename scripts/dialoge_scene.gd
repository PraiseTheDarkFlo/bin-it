extends Node2D

@onready var level_00: TextureRect = $Level00
@onready var level_01: TextureRect = $Level01
@onready var level_02: TextureRect = $Level02
@onready var level_03: TextureRect = $Level03
@onready var button_overview: Button = $ButtonOverview


var backgrounds = {}  

func _ready():
	backgrounds = {
		0: level_00,
		1: level_01,
		2: level_02,
		3: level_03,
	}
	
func set_background(level: int) -> void:
	if level in backgrounds.keys():
		for i in backgrounds.keys():
			if backgrounds[i] != null:
				backgrounds[i].visible = (i == level)
				
