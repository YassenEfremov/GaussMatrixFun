class_name Row extends Node2D


@export var values: Array[int]

var touched: bool = false
var offset: Vector2
var prev_pos: Vector2
var t: Timer

signal picked_up(row: Row, slot)
signal dragged(row: Row)
signal dropped(row: Row)
signal decided


func _ready():
	$Label1.text = str(values[0])
	$Label2.text = str(values[1])
	$Label3.text = str(values[2])
	$Label4.text = str(values[3])
	t = $Timer
	t.timeout.connect(func(): decided.emit())

func _unhandled_input(event):
	# Dragging is done here because the other method stops being called if you drag too fast
	if event is InputEventScreenDrag and touched:
		global_position = event.position + offset
		dragged.emit(self)
		
		t.start(t.wait_time)

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.pressed:
			picked_up.emit(self, get_parent())
			offset = global_position - event.position
			touched = true
		elif touched:
			dropped.emit(self)
			t.stop()
			touched = false
