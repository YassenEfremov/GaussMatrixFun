class_name Row extends Node2D


@export var values: Array[int]

var touched: bool = false
var offset: Vector2
var orig_pos: Vector2
var t: Timer

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
	if event is InputEventScreenDrag and touched:
		global_position = event.position + offset
		dragged.emit(self, event.velocity.length())
	
		t.start(t.wait_time)

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.pressed:
			orig_pos = event.position
			picked_up.emit(self, get_parent())
			offset = global_position - event.position
			touched = true
		elif touched:
			if event.position == orig_pos:
				#locked = not locked
				clicked.emit(self)
			dropped.emit(self)
			t.stop()
			touched = false

func _on_timer_timeout():
	decided.emit()

func divide(value: int):
	for i in values.size():
		values[i] /= value
	update_labels()

func update_labels():
	for i in values.size():
		get_node("Label%d" % (i+1)).text = str(values[i])
