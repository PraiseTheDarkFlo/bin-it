extends Control

signal level_selected(level: int);
@onready var menu_bgm: AudioStreamPlayer = $menuBGM
@onready var level_hover_sound: AudioStreamPlayer = $LevelHoverSound

@onready var button1: Button = $Button1
@onready var button2: Button = $Button2
@onready var button3: Button = $Button3

func _ready() -> void:
	if menu_bgm and not menu_bgm.playing:
		menu_bgm.play()
	_on_draw() # Call _on_draw as it was originally in _ready or equivalent
	if button1:
		button1.mouse_entered.connect(_on_level_button_mouse_entered)
		# Keep its original pressed connection, or ensure it emits level_selected
		button1.pressed.connect(Callable(self, "level_selected").bind(1)) # Example: if it emits directly
	if button2:
		button2.mouse_entered.connect(_on_level_button_mouse_entered)
		button2.pressed.connect(Callable(self, "level_selected").bind(2))
	if button3:
		button3.mouse_entered.connect(_on_level_button_mouse_entered)
		button3.pressed.connect(Callable(self, "level_selected").bind(3))

func _exit_tree() -> void:
	if menu_bgm and menu_bgm.playing:
		var fade_out_duration = 0.5 # Duration of the fade-out in seconds
		var tween = create_tween()
		# Tween volume to low
		tween.tween_property(menu_bgm, "volume_db", -60.0, fade_out_duration)
		await tween.finished 
		menu_bgm.stop() # Stop the music after fade out
		
func set_stars(level: int, count: int) -> void:
	match level:
		1:
			$Stars1.set_stars(count)
		2: 
			$Stars2.set_stars(count)
		3: 
			$Stars3.set_stars(count)		

func _on_draw() -> void:
	for i in range(1,self.get_parent().level_stars.size()+1):
		set_stars(i,self.get_parent().level_stars[i]);
		check_unlock(i,self.get_parent().level_stars[i])
				
func check_unlock(level: int, count: int):
	match level:
		1:
			if count > 0:
				$Button2.disabled = false
				$Stars2.visible = true
				$Lock2.visible = false
			else:
				$Button2.disabled = true
				$Stars2.visible = false
				$Lock2.visible = true	
		2:
			if count > 0:
				$Button3.disabled = false
				$Stars3.visible = true
				$Lock3.visible = false
			else:
				$Button3.disabled = true
				$Stars3.visible = false
				$Lock3.visible = true	
				
func _on_level_button_mouse_entered() -> void:
	if level_hover_sound and not level_hover_sound.playing:
		level_hover_sound.play()
