extends Node2D

var input_state = preload("res://scripts/input_states.gd")
var btn_r = input_state.new("ui_r")
var btn_esc = input_state.new("ui_cancel")
var ray = null
var ray2 = null
var ray_37 = null
var collion_on = ""

func _ready():
	ray_37 = get_node("Wall/wall37/RayCast2D")
	ray_37.add_exception(self)
	ray_37.add_exception(get_node("Wall/wall37"))
	set_fixed_process(true)

func _fixed_process(delta):
	
	if ray_37.is_colliding():
		collion_on = ray_37.get_collider().get_name()
		print(collion_on)
		if collion_on == "player":
			get_node("Wall/wall37/CollisionShape2D").set_trigger(true)
		else:
			get_node("Wall/wall37/CollisionShape2D").set_trigger(false)
	
	if btn_r.check() == 1:
		get_tree().reload_current_scene()
		
	if btn_esc.check() == 1:
		get_tree().change_scene("res://world.tscn")
		
	if get_node("Mushroom3/Mushroom/character_sprites").is_visible() == false:
		get_node("win").show()