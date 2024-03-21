extends Control


func _on_back_to_levels_button_pressed():
	hide()
	$"../LevelSelect".curr_level.queue_free()
	$"../LevelSelect".show()
