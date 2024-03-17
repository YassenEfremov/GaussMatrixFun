class_name Row extends Node2D


@export var values: Array[int]

var touched: bool = false
var offset: Vector2
var orig_pos: Vector2
var t: Timer
var divider: Divider = null
var divider_scene := preload("res://scenes/divider.tscn")

signal picked_up(row: Row, slot)
signal dragged(row: Row, velocity: float)
signal dropped(row: Row)
signal decided
signal clicked(row: Row)


func _ready():
	update_labels()
	t = $Timer

func _unhandled_input(event):
	# Dragging is done here because the other method stops being called if you drag too fast
	if event is InputEventScreenDrag and touched and not $"/root/Main/LinearSystem".locked:	# BAD
		global_position = event.position + offset
		dragged.emit(self, event.velocity.length())
	
		t.start(t.wait_time)

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch and not $"/root/Main/LinearSystem".locked:	# BAD
		if event.pressed:
			orig_pos = event.position
			picked_up.emit(self, get_parent())
			offset = global_position - event.position
			touched = true
		elif touched:
			if event.position == orig_pos:
				#locked = not locked
				clicked.emit(self)
			else:
				dropped.emit(self)
			t.stop()
			touched = false

func _on_timer_timeout():
	decided.emit()

func add(row: Row):
	for i in values.size():
		values[i] += row.values[i]
	update_labels()
	update_divider()

func divide(value: int):
	for i in values.size():
		values[i] /= value
	update_labels()
	divider = null

func multiply(value: int):
	for i in values.size():
		values[i] *= value
	update_labels()
	update_divider()

func update_labels():
	for i in values.size():
		get_node("Label%d" % (i+1)).text = str(values[i])

func update_divider():
	var row_gcd: int = Global.gcd(values)
	if row_gcd != 1:
		if divider:
			divider.update_value(row_gcd)
		else:
			divider = divider_scene.instantiate()
			divider.row = self
			divider.value = row_gcd
			$"/root/Main/SafeArea/GUI/GaussView".add_child(divider)
	elif divider:
		divider.queue_free()
