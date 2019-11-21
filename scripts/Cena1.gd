extends Node2D

const Planta = preload("res://scenes/Planta.tscn")
var plantas = []


func _physics_process(delta):
	pass
	"""for planta in plantas:
		if(planta.desenvolvida == true):
			planta.queue_free()"""

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		var planta = Planta.instance()
		planta.position = event.position
		plantas.append(planta)
		add_child(planta)