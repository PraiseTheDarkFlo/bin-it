extends HBoxContainer

func set_stars(count: int) -> void:
	if count > 0 and count <= get_child_count():
		for i in range(count):
			get_child(i).play("Full")
		for i in range(count,get_child_count()):
			get_child(i).play("Empty")
