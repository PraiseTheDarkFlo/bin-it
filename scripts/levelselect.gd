extends Control

signal level_selected(level: int);


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
				
