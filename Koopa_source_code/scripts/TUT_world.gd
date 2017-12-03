extends Node2D

var input_state = preload("res://scripts/input_states.gd")
var btn_r = input_state.new("ui_r")
var btn_esc = input_state.new("ui_cancel")
var ray = null
var ray2 = null

func _ready():
	ray = get_node("Wall6/wall1_15/RayCast2D")
	ray2 = get_node("Wall6/wall1_15/RayCast2D1")
	
	ray.add_exception(self)
	ray2.add_exception(self)
	set_fixed_process(true)

func _fixed_process(delta):
	
	if ray2.is_colliding():
		get_tree().change_scene("res://World1.tscn")
		
	if btn_esc.check() == 1:
		get_tree().change_scene("res://world.tscn")
	
	if ray.is_colliding():
		print('restart')
		get_tree().reload_current_scene()
	
	if btn_r.check() == 1:
		get_tree().reload_current_scene()