extends Control


signal complete


func _on_linear_system_solved():
	complete.emit()

func _on_tree_exiting():
	if $LinearSystem.multiplier:
		$LinearSystem.multiplier.queue_free()
	for rs in $LinearSystem.get_node("Rows").get_children():
		if rs.get_child(2).divider:
			rs.get_child(2).divider.queue_free()
			rs.get_child(2).divider = null
