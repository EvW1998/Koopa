extends RigidBody2D

export var player_speed = -100
export var player_jump_height = 50

var CHARASTATE = "alive"

var anim_speed = 1.0
var anim_blend = 0.2
var counter = 0
var counter_jump = 0

var raycast_down = null
var raycast_left = null
var raycast_right = null
var raycast_up = null
var anim_player = null
var is_colliding_on = null

##### state #####
var ORIENTATION_PREV = ""
var ORIENTATION = ""
var ORIENTATION_NEXT = "left"

var anim = ""
var anim_new = ""

func is_on_ground():
	
	if raycast_down.is_colliding():
		return true
	return false
	
func is_on_screen():
	pass

func _ready():
	
	set_mode(2)
	raycast_left = get_node("RayCast2D_Left")
	raycast_left.add_exception(self)
	raycast_right = get_node("RayCast2D_Right")
	raycast_right.add_exception(self)
	raycast_down = get_node("RayCast2D_Down")
	raycast_down.add_exception(self)
	raycast_up = get_node("RayCast2D_Up")
	raycast_up.add_exception(self)
	anim_player = get_node("character_sprites/AnimationPlayer")
	
	set_fixed_process(true)

func _fixed_process(delta):
	
	ORIENTATION_PREV = ORIENTATION
	ORIENTATION = ORIENTATION_NEXT
	
	if CHARASTATE == "alive":
		
		if (raycast_left.is_colliding() or raycast_right.is_colliding()) and counter > 2.0:
			player_speed = player_speed * (-1)
			counter = 0
			print("change")
			
		if counter_jump > 4.0 and is_on_ground():
			counter_jump = 0
			set_linear_velocity(Vector2(get_linear_velocity().x, -player_jump_height))
		
		if get_linear_velocity().y > 1:
			anim = "jump_down"
			anim_speed = 1.0
			anim_blend = 0.0
		elif get_linear_velocity().y < -1:
			anim = "jump_up"
			anim_speed = 1.0
			anim_blend = 0.0
			
		if not is_on_ground():
			set_linear_velocity(Vector2(player_speed, get_linear_velocity().y))
			
		if raycast_up.is_colliding():
			is_colliding_on = raycast_up.get_collider().get_name()
			if is_colliding_on == "player":
				CHARASTATE = "die"
				anim = "die"
				counter = 0
				
		if raycast_down.is_colliding():
			is_colliding_on = raycast_down.get_collider().get_name()
			if is_colliding_on == "player":
				CHARASTATE = "die"
				anim = "die"
				counter = 0
				
		if raycast_left.is_colliding():
			is_colliding_on = raycast_left.get_collider().get_name()
			if is_colliding_on == "player":
				CHARASTATE = "die"
				anim = "die"
				counter = 0
				
		if raycast_right.is_colliding():
			is_colliding_on = raycast_right.get_collider().get_name()
			if is_colliding_on == "player":
				CHARASTATE = "die"
				anim = "die"
				counter = 0
			
			
		if anim != anim_new:
			anim_new = anim
			anim_player.play(anim,anim_blend,anim_speed)
		
		counter += 0.1
		counter_jump += 0.1
		
	else:
		print("kill")
		counter += 0.1
		if counter > 3.0:
			get_node("character_sprites").hide()
			get_node("CollisionShape2D").set_trigger(true)