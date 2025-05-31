extends Label

@onready var level_state: Node = %LevelState

func _ready() -> void:
	text = "Score: " + str(level_state.score) 
