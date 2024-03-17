class_name Divider extends Button


var row: Row
var value: int


func _ready():
	name = "Divider%d" % row.get_parent().get_index()
	$Value.text = str(value)

func _process(delta):												# vv  not great  vv
	global_position = row.global_position + 250 * Vector2.RIGHT + (size.y/2 * Vector2.UP)

func _pressed():
	row.divide(value)
	row.divider = null	# Ughmm..
	queue_free()

func update_value(new_value: int):
	value = new_value
	$Value.text = str(new_value)
