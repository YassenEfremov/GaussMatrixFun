class_name Row extends Node2D


@export var values: Array[int]

var touched: bool = false
var initialPos: Vector2
var offset: Vector2

signal picked_up(row: Row, slot)
signal dropped(row: Row)
#signal dropped


func _ready():
	$Label1.text = str(values[0])
	$Label2.text = str(values[1])
	$Label3.text = str(values[2])
	$Label4.text = str(values[3])

func _unhandled_input(event):
	# Dragging is done here because the other method stops being called if you drag too fast
	if event is InputEventScreenDrag and touched:
		global_position = event.position + offset

func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventScreenTouch:
		if event.pressed:
			picked_up.emit(self, get_parent())
			initialPos = global_position
			offset = global_position - event.position
			touched = true
		else:
			dropped.emit(self)
			touched = false
