extends Node2D

var ray_help = null
var ray_quit = null
var ray_start = null

func _ready():
	ray_help = get_node("help/RayCast2D1")
	ray_quit = get_node("quit/RayCast2D")
	ray_start = get_node("start/RayCast2D1")
	
	ray_help.add_exception(self)
	ray_quit.add_exception(self)
	ray_start.add_exception(self)
	set_fixed_process(true)

func _fixed_process(delta):
	
	if ray_help.is_colliding():
		print("tut")
		get_tree().change_scene("res://TUT_world.tscn")
	
	if ray_start.is_colliding():
		print("level")
		get_tree().change_scene("res://World1.tscn")
	
	if ray_quit.is_colliding():
		get_tree().quit()
