@tool
extends Control


@export var solution_index: int:
	set(value):
		solution_index = value
		$SolutionIndex.text = str(solution_index)

var solution: float:
	set(value):
		solution = value
		$Value.text = str(solution)