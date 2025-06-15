extends Node

enum game_states{INTRO,LEVEL_SELECT,PRE_LEVEL,INGAME,POST_LEVEL,OUTTRO}

var state: game_states = game_states.INTRO;
var current_level: int = -1;
var level_select_instance = null;
var level_instance = null;
var dialoge_instance = null;
var dialoge_ballon= null;
var level_stars = {
	1: 0,
	2: 0,
	3: 0,
}

signal on_state_change(new_state: game_states);

func update_state(new_state: game_states) -> void:
	var debug_str = str("Game State: ", game_states.keys()[new_state]);
	if(current_level > 0):
		debug_str = str(debug_str, " (", current_level, ")");
	print(debug_str);
	state = new_state;
	on_state_change.emit(new_state);
	
# Start: Display Intro
func _on_game_ready() -> void:
	DialogueManager.dialogue_ended.connect(on_intro_finished);
	var scene = load("res://scenes/dialoge_scene.tscn");
	dialoge_instance = scene.instantiate();
	add_child(dialoge_instance);
	dialoge_instance.set_background(0)
	var scene_ballon = load("res://scenes/balloon.tscn");
	dialoge_ballon = scene_ballon.instantiate();
	add_child(dialoge_ballon);
	dialoge_ballon.start(load("res://dialogues/intro.dialogue"),"start")

func on_intro_finished(resource: DialogueResource) -> void:
	print("Intro finished!");#
	DialogueManager.dialogue_ended.disconnect(on_intro_finished);
	showLevelSelect();

func showLevelSelect() -> void:
	update_state(game_states.LEVEL_SELECT);
	if(level_select_instance == null):
		var scene = load("res://scenes/levelselect.tscn");
		level_select_instance = scene.instantiate();
		level_select_instance.level_selected.connect(on_select_level);
	add_child(level_select_instance);

func on_select_level(level: int) -> void:
	current_level = level;
	dialoge_instance.set_background(level)
	update_state(game_states.PRE_LEVEL);
	remove_child(level_select_instance); # The level selector can be reused, no need to reinstantiate it
	DialogueManager.dialogue_ended.connect(on_prelevel_finished);
	DialogueManager.show_dialogue_balloon(load(str("res://dialogues/level_", level, "_pre.dialogue")));

func on_prelevel_finished(resource: DialogueResource) -> void:
	update_state(game_states.INGAME);	
	DialogueManager.dialogue_ended.disconnect(on_prelevel_finished);
	load_current_level()
	
func load_current_level():
	var scene = load("res://scenes/level.tscn");
	level_instance = scene.instantiate();
	level_instance.get_node("LevelState").level_finished.connect(on_level_finished);
	add_child(level_instance);
	match current_level:
		1:
			level_instance.init(1,18,1000,2000,5000) #18
		2:
			level_instance.init(2,12,4000,6000,10000)	
		3:
			level_instance.init(3,9,2000,3000,8000)
		_:
			stop_level()			
			
func stop_level():
	if level_instance != null:
		level_instance.get_node("LevelState").level_finished.disconnect(on_level_finished);
		level_instance.call_deferred("queue_free")
		level_instance = null;
					
					


func on_level_finished(stars: int) -> void:
	var timer := Timer.new()
	timer.wait_time = 2.0  
	timer.one_shot = true
	add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()
	
	level_instance.get_node("LevelState").level_finished.disconnect(on_level_finished);
	level_instance.call_deferred("queue_free")
	if level_stars[current_level] > 0:
		update_stars(current_level,stars)
		current_level = -1;
		level_instance = null;
		showLevelSelect();
	else:	 
		update_stars(current_level,stars)
		if stars > 0:
			update_state(game_states.POST_LEVEL);
			DialogueManager.dialogue_ended.connect(on_postlevel_finished);
			DialogueManager.show_dialogue_balloon(load(str("res://dialogues/level_", current_level, "_post.dialogue")));
		else:
			update_state(game_states.POST_LEVEL);
			DialogueManager.dialogue_ended.connect(on_postlevel_finished);
			DialogueManager.show_dialogue_balloon(load(str("res://dialogues/level_failed.dialogue")));
			

	
func update_stars(level: int, stars: int) -> void:
	if level in level_stars:
		if stars > level_stars[level]:
			level_stars[level] = stars
	print(level_stars)	

func on_postlevel_finished(resource: DialogueResource) -> void:
	current_level = -1;
	DialogueManager.dialogue_ended.disconnect(on_postlevel_finished);
	level_instance = null;
	showLevelSelect();

func reset_overview():
	dialoge_instance.button_overview.overview = null
func set_overview(overview):
	dialoge_instance.button_overview.overview = overview
