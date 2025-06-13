extends HBoxContainer


var rainbow_mode = false
var time = 0.0
var current_mul = 1.0

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
	rainbow_mode = number > 1.0
	current_mul = number
	var score = "%05.2f" % number
	for i in range(score.length()):
		var char = score[i]
		if char == ".":
			continue
		else:
			get_child(i+1).texture.region = Rect2(digit_coords[int(char)], Vector2(8, 8))
			
func _process(delta):
	if rainbow_mode:
		time += delta * _rainbow_speed()
		for i in get_child_count():
			var digit_node = get_child(i)
			var hue = fmod(time + i * 0.1, 1.0)
			digit_node.modulate = Color.from_hsv(hue, 0.9, 1.0)
	else:
		for i in get_child_count():
			get_child(i).modulate = Color.WHITE		
			
func _rainbow_speed() -> float:
	var min_speed = 0.2
	var max_speed = 0.76
	var t = clamp((current_mul - 1.0) / 1.0, 0.0, 1.0)  
	t = pow(t, 2.5)  
	return lerp(min_speed, max_speed, t)
