extends Node2D

func _on_ready() -> void:
	$CanvasLayer/PaperCan.animated_sprite.play("Paper")
	$CanvasLayer/PlasticCan.animated_sprite.play("Yellow")
	$CanvasLayer/RestCan.animated_sprite.play("Rest")
	$CanvasLayer/BioCan.animated_sprite.play("Bio")
	$CanvasLayer/Blitz.animated_sprite.play("speedup")
	$CanvasLayer/Blitz.timer.paused = true
	$CanvasLayer/Minus.animated_sprite.play("multiplierDown")
	$CanvasLayer/Minus.timer.paused = true
	$CanvasLayer/Fire.animated_sprite.play("multiplierUp")
	$CanvasLayer/Fire.timer.paused = true
	$CanvasLayer/Slow.animated_sprite.play("slowdown")
	$CanvasLayer/Slow.timer.paused = true
	$CanvasLayer/Paper1.showMode = true
	$CanvasLayer/Paper1.animated_sprite.play("Box")
	$CanvasLayer/Paper2.showMode = true
	$CanvasLayer/Paper2.animated_sprite.play("Flyer")
	$CanvasLayer/Paper3.showMode = true
	$CanvasLayer/Paper3.animated_sprite.play("Magazine")
	$CanvasLayer/Paper4.showMode = true
	$CanvasLayer/Paper4.animated_sprite.play("Paper_ball")
	$CanvasLayer/Paper5.showMode = true
	$CanvasLayer/Paper5.animated_sprite.play("Sheet_of_paper")
	$CanvasLayer/Paper6.showMode = true
	$CanvasLayer/Paper6.animated_sprite.play("Papier_rollen")
	$CanvasLayer/Paper7.showMode = true
	$CanvasLayer/Paper7.animated_sprite.play("Nudeln")
	$CanvasLayer/Plastic1.showMode = true
	$CanvasLayer/Plastic1.animated_sprite.play("Folie")
	$CanvasLayer/Plastic2.showMode = true
	$CanvasLayer/Plastic2.animated_sprite.play("Tube")
	$CanvasLayer/Plastic3.showMode = true
	$CanvasLayer/Plastic3.animated_sprite.play("Milk")
	$CanvasLayer/Plastic4.showMode = true
	$CanvasLayer/Plastic4.animated_sprite.play("Gifflar")
	$CanvasLayer/Plastic5.showMode = true
	$CanvasLayer/Plastic5.animated_sprite.play("Mozzarella")
	$CanvasLayer/Plastic6.showMode = true
	$CanvasLayer/Plastic6.animated_sprite.play("Tesa")
	$CanvasLayer/Plastic7.showMode = true
	$CanvasLayer/Plastic7.animated_sprite.play("Dose")
	$CanvasLayer/Bio1.showMode = true
	$CanvasLayer/Bio1.animated_sprite.play("Apple")
	$CanvasLayer/Bio2.showMode = true
	$CanvasLayer/Bio2.animated_sprite.play("Banana")
	$CanvasLayer/Bio3.showMode = true
	$CanvasLayer/Bio3.animated_sprite.play("Leafs")
	$CanvasLayer/Bio4.showMode = true
	$CanvasLayer/Bio4.animated_sprite.play("Loewenzahn")
	$CanvasLayer/Bio5.showMode = true
	$CanvasLayer/Bio5.animated_sprite.play("Stick")
	$CanvasLayer/Bio6.showMode = true
	$CanvasLayer/Bio6.animated_sprite.play("Sticks")
	$CanvasLayer/Bio7.showMode = true
	$CanvasLayer/Bio7.animated_sprite.play("Straw")
	$CanvasLayer/Rest1.showMode = true
	$CanvasLayer/Rest1.animated_sprite.play("Backpapier")
	$CanvasLayer/Rest2.showMode = true
	$CanvasLayer/Rest2.animated_sprite.play("Bong")
	$CanvasLayer/Rest3.showMode = true
	$CanvasLayer/Rest3.animated_sprite.play("Ordner")
	$CanvasLayer/Rest4.showMode = true
	$CanvasLayer/Rest4.animated_sprite.play("Picture")
	$CanvasLayer/Rest5.showMode = true
	$CanvasLayer/Rest5.animated_sprite.play("Zigarette")
	$CanvasLayer/Rest6.showMode = true
	$CanvasLayer/Rest6.animated_sprite.play("Scherben")
	$CanvasLayer/Rest7.showMode = true
	$CanvasLayer/Rest7.animated_sprite.play("Stifte")
	$CanvasLayer/Button2.visible = false
	$CanvasLayer/Button3.visible = false
	
func show_only_level_relevant(level: int):
	match level:
		1:
			$CanvasLayer/RestCan.visible = false
			$CanvasLayer/BioCan.visible = false
			$CanvasLayer/Blitz.visible = false
			$CanvasLayer/Minus.visible = false
			$CanvasLayer/Fire.visible = false
			$CanvasLayer/Slow.visible = false
			$CanvasLayer/Power_up.visible = false
			$CanvasLayer/Power_down.visible = false
			$CanvasLayer/BlitzInfo.visible = false
			$CanvasLayer/PowerDown.visible = false
			$CanvasLayer/PowerUp.visible = false
			$CanvasLayer/MinusInfo.visible = false
			$CanvasLayer/FireInfo.visible = false
			$CanvasLayer/SlowInfo.visible = false
			$CanvasLayer/Bio1.visible = false
			$CanvasLayer/Bio2.visible = false
			$CanvasLayer/Bio3.visible = false
			$CanvasLayer/Bio4.visible = false
			$CanvasLayer/Bio5.visible = false
			$CanvasLayer/Bio6.visible = false
			$CanvasLayer/Bio7.visible = false
			$CanvasLayer/Rest1.visible = false
			$CanvasLayer/Rest2.visible = false
			$CanvasLayer/Rest3.visible = false
			$CanvasLayer/Rest4.visible = false
			$CanvasLayer/Rest5.visible = false
			$CanvasLayer/Rest6.visible = false
			$CanvasLayer/Rest7.visible = false
		2:
			$CanvasLayer/RestCan.visible = false
			$CanvasLayer/BioCan.visible = true
			$CanvasLayer/Blitz.visible = false
			$CanvasLayer/Minus.visible = false
			$CanvasLayer/Fire.visible = true
			$CanvasLayer/Slow.visible = true
			$CanvasLayer/Power_up.visible = true
			$CanvasLayer/Power_down.visible = false
			$CanvasLayer/BlitzInfo.visible = false
			$CanvasLayer/PowerDown.visible = false
			$CanvasLayer/PowerUp.visible = true
			$CanvasLayer/MinusInfo.visible = false
			$CanvasLayer/FireInfo.visible = true
			$CanvasLayer/SlowInfo.visible = true
			$CanvasLayer/Bio1.visible = true
			$CanvasLayer/Bio2.visible = true
			$CanvasLayer/Bio3.visible = true
			$CanvasLayer/Bio4.visible = true
			$CanvasLayer/Bio5.visible = true
			$CanvasLayer/Bio6.visible = true
			$CanvasLayer/Bio7.visible = true
			$CanvasLayer/Rest1.visible = false
			$CanvasLayer/Rest2.visible = false
			$CanvasLayer/Rest3.visible = false
			$CanvasLayer/Rest4.visible = false
			$CanvasLayer/Rest5.visible = false
			$CanvasLayer/Rest6.visible = false
			$CanvasLayer/Rest7.visible = false
		3:	
			$CanvasLayer/RestCan.visible = true
			$CanvasLayer/BioCan.visible = true
			$CanvasLayer/Blitz.visible = true
			$CanvasLayer/Minus.visible = true
			$CanvasLayer/Fire.visible = true
			$CanvasLayer/Slow.visible = true
			$CanvasLayer/Power_up.visible = true
			$CanvasLayer/Power_down.visible = true
			$CanvasLayer/BlitzInfo.visible = true
			$CanvasLayer/PowerDown.visible = true
			$CanvasLayer/PowerUp.visible = true
			$CanvasLayer/MinusInfo.visible = true
			$CanvasLayer/FireInfo.visible = true
			$CanvasLayer/SlowInfo.visible = true
			$CanvasLayer/Bio1.visible = true
			$CanvasLayer/Bio2.visible = true
			$CanvasLayer/Bio3.visible = true
			$CanvasLayer/Bio4.visible = true
			$CanvasLayer/Bio5.visible = true
			$CanvasLayer/Bio6.visible = true
			$CanvasLayer/Bio7.visible = true
			$CanvasLayer/Rest1.visible = true
			$CanvasLayer/Rest2.visible = true
			$CanvasLayer/Rest3.visible = true
			$CanvasLayer/Rest4.visible = true
			$CanvasLayer/Rest5.visible = true
			$CanvasLayer/Rest6.visible = true
			$CanvasLayer/Rest7.visible = true
		_:
			$CanvasLayer/RestCan.visible = true
			$CanvasLayer/BioCan.visible = true
			$CanvasLayer/Blitz.visible = true
			$CanvasLayer/Minus.visible = true
			$CanvasLayer/Fire.visible = true
			$CanvasLayer/Slow.visible = true
			$CanvasLayer/Power_up.visible = true
			$CanvasLayer/Power_down.visible = true
			$CanvasLayer/BlitzInfo.visible = true
			$CanvasLayer/PowerDown.visible = true
			$CanvasLayer/PowerUp.visible = true
			$CanvasLayer/MinusInfo.visible = true
			$CanvasLayer/FireInfo.visible = true
			$CanvasLayer/SlowInfo.visible = true
			$CanvasLayer/Bio1.visible = true
			$CanvasLayer/Bio2.visible = true
			$CanvasLayer/Bio3.visible = true
			$CanvasLayer/Bio4.visible = true
			$CanvasLayer/Bio5.visible = true
			$CanvasLayer/Bio6.visible = true
			$CanvasLayer/Bio7.visible = true
			$CanvasLayer/Rest1.visible = true
			$CanvasLayer/Rest2.visible = true
			$CanvasLayer/Rest3.visible = true
			$CanvasLayer/Rest4.visible = true
			$CanvasLayer/Rest5.visible = true
			$CanvasLayer/Rest6.visible = true
			$CanvasLayer/Rest7.visible = true
			
func show_buttons():
	$CanvasLayer/Button2.visible = true
	$CanvasLayer/Button3.visible = true
