class_name LinearSystem extends Node2D


#@export var two_dimensional: Array[Array] = [[1, 0], [0, 1]]
var number_of_rows: int = 4

var selected_row: Row
var selected_slot: RowSlot
var slot_distances = {}
var closest_slot: RowSlot
var swap: bool = true
var decided: bool = false
var multiplier: Multiplier = null
var multiplier_scene := preload("res://scenes/multiplier.tscn")
var locked: bool = false


func shift_down(i):
	if i == number_of_rows - 1: return
	if $Rows.get_child(i + 1).get_children().size() > 2:	# BAD CODE!!!
		shift_down(i + 1)
	#print("moving ", i, " -> ", i + 1)
	move_row(i, i + 1)

func shift_up(i):
	if i == 0: return
	if $Rows.get_child(i - 1).get_children().size() > 2:	# BAD CODE!!!
		shift_up(i - 1)
	#print("moving ", i, " -> ", i - 1)
	move_row(i, i - 1)

func move_row(from_i: int, to_i: int):
	var tween = get_tree().create_tween()
	$Rows.get_child(from_i).get_child(2).reparent($Rows.get_child(to_i))
	tween.tween_property($Rows.get_child(to_i).get_child(2), "position", Vector2.ZERO, 0.2).set_ease(Tween.EASE_OUT)
	#print(from_i, " -> ", to_i)

func row_picked_up(row: Row, slot: RowSlot):
	selected_row = row
	selected_slot = slot
	closest_slot = selected_slot
	
	selected_row.reparent($Dragging)

func on_dragged(row: Row, velocity: float):
	for row_slot in $Rows.get_children():
		slot_distances[row_slot] = row_slot.global_position.distance_to(selected_row.global_position)
	var new_closest = slot_distances.find_key(slot_distances.values().min())
	
	if decided:
		if swap:
			if new_closest != closest_slot:
				if closest_slot.get_index() > new_closest.get_index():
					# Shift all rows BELOW the closest slot
					if selected_row.position.y < new_closest.position.y and $Rows.get_child(new_closest.get_index()).get_children().size() > 2:
						#print("shifting DOWN from ", new_closest.get_index())
						shift_down(new_closest.get_index())
					elif $Rows.get_child(new_closest.get_index() + 1).get_children().size() > 2:
						shift_down(new_closest.get_index() + 1)
				elif closest_slot.get_index() < new_closest.get_index():
					# Shift all rows ABOVE the closest slot
					if selected_row.position.y > new_closest.position.y and $Rows.get_child(new_closest.get_index()).get_children().size() > 2:
						#print("shifting UP from ", new_closest.get_index())
						shift_up(new_closest.get_index())
					elif $Rows.get_child(new_closest.get_index() - 1).get_children().size() > 2:
						shift_up(new_closest.get_index() - 1)
				closest_slot = new_closest
		elif slot_distances.find_key(slot_distances.values().min()).get_children().size() > 2:		# BAD CODE!!!
			slot_distances.find_key(slot_distances.values().min()).modulate = Color.GRAY
			#swap = true		# breaks row addition/subtraction
		
		decided = false
	elif velocity > 200:
		new_closest.modulate = Color.WHITE

func row_dropped(row: Row):
	selected_row = null
	
	var closest = slot_distances.find_key(slot_distances.values().min())
	if not swap and closest.get_children().size() > 2:	# BAD CODE!!!
		# add/subtract here
		closest.get_child(2).add(row)
		swap = true
	
	# Return the selected row back
	for r in $Rows.get_children():
		if r.get_children().size() <= 2:
			row.reparent(r)
			#print("reparent")
		r.modulate = Color.WHITE
	
	var tween = get_tree().create_tween()
	tween.tween_property(row, "position", Vector2.ZERO, 0.2).set_ease(Tween.EASE_OUT)
	
	#if slot_distances.find_key(slot_distances.values().min()):
		#slot_distances.find_key(slot_distances.values().min()).modulate = Color.WHITE

func on_decided():	# This gets spammed a lot when holding the selected row still
	if slot_distances.values().min() < 20:
		swap = false
	decided = true


func on_clicked(row: Row):
	row.reparent(selected_slot)
	if multiplier:
		selected_slot.modulate = Color.WHITE
		locked = false
		
		$"/root/Main/SafeArea/GUI/GaussView".remove_child(multiplier)
		multiplier = null
	else:
		selected_slot.modulate = Color.GRAY
		locked = true
		
		multiplier = multiplier_scene.instantiate()
		multiplier.row = row
		$"/root/Main/SafeArea/GUI/GaussView".add_child(multiplier)


func _on__found_solution(x, i):
	get_node("Solutions/Solution%d" % i).solution = x
