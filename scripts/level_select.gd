extends Control


var curr_level


func _ready():
	for lb in $GridContainer.get_children():
		lb.pressed.connect(play_level.bind(lb.get_index() + 1))
	
	for l in $"/root/Main/Levels".get_children():
		l.complete.connect(complete_level.bind(l.get_index()))

func _on_back_button_pressed():
	hide()
	$"../MainMenu".show()

func play_level(number):
	curr_level = load("res://scenes/levels/level%d.tscn" % number).instantiate()
	hide()
	$"/root/Main/Levels".add_child(curr_level)
	#curr_level.show()
	$"../GaussView".show()

func complete_level(number):
	print("completed level %d" % number)
