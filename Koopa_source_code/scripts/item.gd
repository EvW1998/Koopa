extends RigidBody2D

var count = 0
var ray1 = null
var ray2 = null
var ray3 = null

func _ready():
	
	ray1 = get_node("RayCast2D")
	ray1.add_exception(self)
	ray2 = get_node("RayCast2D1")
	ray2.add_exception(self)
	ray3 = get_node("RayCast2D2")
	ray3.add_exception(self)
	
	set_mode(2)
	set_fixed_process(true)

func _fixed_process(delta):
	
	if count > 4.0:
		get_node("character_sprites/AnimationPlayer").play("row", 0.2, 2.0)
		count = 0
	count += 0.1
	
	if ray1.is_colliding() or ray2.is_colliding() or ray3.is_colliding():
		print("tage")
		get_node("CollisionShape2D").set_trigger(true)
		get_node("character_sprites").hide()