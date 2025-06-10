extends HBoxContainer

var digit_coords = {
	0: Vector2(32,8),
	1: Vector2(0,0),
	2: Vector2(8,0),
	3: Vector2(16,0),
	4: Vector2(24,0),
	5: Vector2(32,0),
	6: Vector2(0,8),
	7: Vector2(8,8),
	8: Vector2(16,8),
	9: Vector2(24,8),
}

func update_mul(number: float):
	var score = "%05.2f" % number
	for i in range(score.length()):
		var char = score[i]
		if char == ".":
			continue
		else:
			get_child(i+1).texture.region = Rect2(digit_coords[int(char)], Vector2(8, 8))
