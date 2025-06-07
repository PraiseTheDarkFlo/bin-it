extends Node

enum game_states{INTRO,LEVEL_SELECT,PRE_LEVEL,INGAME,POST_LEVEL,OUTTRO}

var state: game_states = game_states.INTRO;
var current_level: int = -1;
var level_select_instance = null;
var level_instance = null;

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
	DialogueManager.show_dialogue_balloon(load("res://dialogues/intro.dialogue"));

func on_intro_finished(resource: DialogueResource) -> void:
	print("Intro finished!");
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
	update_state(game_states.PRE_LEVEL);
	remove_child(level_select_instance); # The level selector can be reused, no need to reinstantiate it
	DialogueManager.dialogue_ended.connect(on_prelevel_finished);
	DialogueManager.show_dialogue_balloon(load(str("res://dialogues/level_", level, "_pre.dialogue")));

func on_prelevel_finished(resource: DialogueResource) -> void:
	update_state(game_states.INGAME);	
	DialogueManager.dialogue_ended.disconnect(on_prelevel_finished);
	var scene = load("res://scenes/level.tscn");
	level_instance = scene.instantiate();
	level_instance.get_node("LevelState").level_finished.connect(on_level_finished);
	add_child(level_instance);

func on_level_finished() -> void:
	level_instance.get_node("LevelState").level_finished.disconnect(on_level_finished);
	update_state(game_states.POST_LEVEL);
	DialogueManager.dialogue_ended.connect(on_postlevel_finished);
	DialogueManager.show_dialogue_balloon(load(str("res://dialogues/level_", current_level, "_post.dialogue")));

func on_postlevel_finished(resource: DialogueResource) -> void:
	current_level = -1;
	DialogueManager.dialogue_ended.disconnect(on_postlevel_finished);
	remove_child(level_instance);
	level_instance = null;
	showLevelSelect();
