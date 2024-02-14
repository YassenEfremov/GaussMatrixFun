class_name LinearSystem extends Node2D


#@export var two_dimensional: Array[Array] = [[1, 0], [0, 1]]
var number_of_rows = 4

var selected_row: Row
var selected_slot
var slot_distances = {}
var closest_slot

func _process(delta):
	if selected_row:
		for row_slot in $Rows.get_children():
			slot_distances[row_slot] = row_slot.global_position.distance_to(selected_row.global_position)
		var new_closest = slot_distances.find_key(slot_distances.values().min())
		print(slot_distances.values().min())
		#if not closest_slot:
			#closest_slot = selected_slot
		if slot_distances.values().min() > 20 and new_closest != closest_slot:
			if closest_slot.get_index() > new_closest.get_index():
				# Shift all rows BELOW the closest slot
				#print("shifting DOWN from ", new_closest.get_index())
				shift_down(new_closest.get_index())
			elif closest_slot.get_index() < new_closest.get_index():
				# Shift all rows ABOVE the closest slot
				#print("shifting UP from ", new_closest.get_index())
				shift_up(new_closest.get_index())
			closest_slot = new_closest

func shift_down(i):
	if i == number_of_rows - 1: return
	if not $Rows.get_child(i + 1).get_children().size() <= 2:	# BAD CODE!!!
		shift_down(i + 1)
	else:
		#print("moving ", i, " -> ", i + 1)
		move_row(i, i + 1)

func shift_up(i):
	if i == 0: return
	if not $Rows.get_child(i - 1).get_children().size() <= 2:	# BAD CODE!!!
		shift_down(i - 1)
	else:
		#print("moving ", i, " -> ", i - 1)
		move_row(i, i - 1)

func move_row(from_i: int, to_i: int):
	var tween = get_tree().create_tween()
	$Rows.get_child(from_i).get_child(2).reparent($Rows.get_child(to_i))
	tween.tween_property($Rows.get_child(to_i).get_child(2), "position", Vector2.ZERO, 0.2).set_ease(Tween.EASE_OUT)

func row_picked_up(row: Row, slot):
	selected_row = row
	selected_slot = slot
	closest_slot = selected_slot
	
	selected_row.reparent($Dragging)

func row_dropped(row: Row):
	selected_row = null
	
	var tween = get_tree().create_tween()
	#if closest_slot.get_children().size() <= 2:		# BAD CODE!!!
		#row.reparent(closest_slot)
	#else:
		#row.reparent(selected_slot)
	#closest_slot = null
	
	# This works better
	for r in $Rows.get_children():
		if r.get_children().size() <= 2:
			row.reparent(r)
	
	tween.tween_property(row, "position", Vector2.ZERO, 0.2).set_ease(Tween.EASE_OUT)
