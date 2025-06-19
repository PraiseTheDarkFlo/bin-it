extends Node2D

signal exit();

var final_size = 0;

func _ready() -> void:
	var credits_file = "res://credits.txt";
	var file = FileAccess.open(credits_file, FileAccess.READ);
	
	var headline_node = get_node("Headline");
	var text_node = get_node("Text");
	
	var next_headline = 0;
	var next_text = 0;
	var next_pos_y = 1025.0;
	
	while not file.eof_reached():
		var line = file.get_line();
		var node = null;
		if line == "# BIN IT!": # This line is already present by the Title Image
			continue;
		
		if line.begins_with("# "):
			line = line.substr(2);
			if next_headline > 0:
				node = headline_node.duplicate();
				add_child(node);
				node.name = str("Headline", next_headline);
			else:
				node = headline_node;
			next_headline += 1;
			next_pos_y += 60;
		else:
			if next_text > 0:
				node = text_node.duplicate();
				add_child(node);
				node.name = str("Text", next_text);
			else:
				node = text_node;
			next_text += 1;
		
		node.position.y = next_pos_y;
		node.text = line;
		next_pos_y += node.get_minimum_size().y + 20;
	final_size = next_pos_y;

func _physics_process(delta: float) -> void:
	position += Vector2(0, -1);
	if (position.y + final_size) < -30:
		exit.emit();

func _process(delta):
	if Input.is_action_just_pressed("skip_credits") and position.y < -20:
		exit.emit();
