extends Node2D

var touched: bool = false
var over_row_slot: bool = false
var entered_row_slot
var initialPos: Vector2


func _unhandled_input(event):
	# Dragging is done here because the other method stops being called if you drag too fast
	if event is InputEventScreenDrag and touched:
		position = event.position


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.pressed:
			initialPos = position
			touched = true
			#Global.selected_row = self
		else:
			var tween = get_tree().create_tween()
			if over_row_slot:
				tween.tween_property(self, "position", entered_row_slot.position, 0.2).set_ease(Tween.EASE_OUT)
			else:
				tween.tween_property(self, "position", initialPos, 0.2).set_ease(Tween.EASE_OUT)
			
			touched = false


func _on_area_2d_body_entered(body):
	if body.is_in_group("dropable") and not over_row_slot:
		over_row_slot = true
		body.modulate = Color(Color.GRAY)
		entered_row_slot = body


func _on_area_2d_body_exited(body):
	if body.is_in_group("dropable") and over_row_slot:
		over_row_slot = false
		body.modulate = Color(Color.WHITE)
