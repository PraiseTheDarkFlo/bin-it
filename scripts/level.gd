extends Node
@onready var level_state: Node = %LevelState

func init(level: int, trash_count: int, first_star:int,second_star:int,third_star:int):
	level_state.set_up_level(level,trash_count)
	level_state.star_thresholds = [first_star,second_star,third_star]
	
