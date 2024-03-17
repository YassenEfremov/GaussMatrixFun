class_name Multiplier extends Label


var row: Row
var value: int = 1


func _ready():
	text = str(value)
	global_position = Vector2(row.global_position.x, (800 * Vector2.DOWN).y)

func _on_decrease_pressed():
	value -= 1
	if value == 0:
		value -= 1;
	text = str(value)

func _on_increase_pressed():
	value += 1
	if value == 0:
		value += 1;
	text = str(value)

func _on_apply_pressed():
	row.multiply(value)
	row.get_parent().modulate = Color.WHITE
	$"/root/Main/LinearSystem".locked = false
	$"/root/Main/LinearSystem".multiplier = null	# Ughmm..
	queue_free()

func _on_cancel_pressed():
	row.get_parent().modulate = Color.WHITE
	$"/root/Main/LinearSystem".locked = false
	$"/root/Main/LinearSystem".multiplier = null	# # Ughmm..
	queue_free()
