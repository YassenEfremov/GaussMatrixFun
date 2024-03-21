@tool
extends Control


@export var solution_index: int:
	set(value):
		solution_index = value
		$SolutionIndex.text = str(solution_index)

var solution: float:
	set(value):
		$Value.scale = Vector2(3, 3)
		solution = value
		$Value.text = str(solution)
		var tween = get_tree().create_tween()
		tween.tween_property($Value, "scale", Vector2.ONE, 0.2)
