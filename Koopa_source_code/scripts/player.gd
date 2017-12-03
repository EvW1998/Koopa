extends RigidBody2D

##### import #####
var input_state = preload("res://scripts/input_states.gd")

##### export var #####
export var player_speed = 200
export var player_acceleraction_ground = 10
export var player_acceleraction_air = 3
export var player_jump_height = 400
export var player_attack_speed = 900

##### var #####
var current_speed = Vector2(0, 0)
var anim_speed = 1.0
var anim_blend = 0.2
var counter = 0
var collion_on = ""

##### node #####
var raycast_down = null
var rotate = null
var anim_player = null
var head = null
var head_2 = null
var head_1 = null
var raycast_right0 = null
var raycast_left0 = null
var raycast_left1 = null

##### state #####
var PLAYERSTATE_PREV = ""
var PLAYERSTATE = ""
var PLAYERSTATE_NEXT = "ground"

var CHARASTATE_PREV = ""
var CHARASTATE = ""
var CHARASTATE_NEXT = "green_normal"

var ORIENTATION_PREV = ""
var ORIENTATION = ""
var ORIENTATION_NEXT = "right"

var GOTO_PREV = ""
var GOTO = ""
var GOTO_NEXT = "stay"

var anim = ""
var anim_new = ""
var anim_prev = ""

##### keyboard input #####
var btn_right = input_state.new("ui_right")
var btn_left = input_state.new("ui_left")
var btn_jump = input_state.new("ui_shift")
var btn_z = input_state.new("ui_z")

###############################################################

func is_on_ground():
	if raycast_down.is_colliding():
		return true
	return false


func rotate_behavior():
	if ORIENTATION == "right" and ORIENTATION_NEXT == "left":
		rotate.set_scale(rotate.get_scale() * Vector2(-1,1))
	elif ORIENTATION == "left" and ORIENTATION_NEXT == "right":
		rotate.set_scale(rotate.get_scale() * Vector2(-1,1))


func move(speed, acc, delta):
	current_speed.x = lerp(current_speed.x, speed, acc * delta)
	set_linear_velocity(Vector2(current_speed.x, get_linear_velocity().y))


func ground_state(delta):
	if btn_left.check() == 2:
		move(-player_speed, player_acceleraction_ground, delta)
		ORIENTATION_NEXT = "left"
		anim = "run"
		anim_speed = 2.0
		anim_blend = 0.2
	elif btn_right.check() == 2:
		move(player_speed, player_acceleraction_ground, delta)
		ORIENTATION_NEXT = "right"
		anim = "run"
		anim_speed = 2.0
		anim_blend = 0.2
	else:
		get_node("rotate/character_sprites/base/body/tail").show()
		get_node("rotate/character_sprites/base/body/head").show()
		get_node("rotate/character_sprites/base/body/foot_right").show()
		get_node("rotate/character_sprites/base/body/foot_left").show()
		get_node("rotate/character_sprites/base/body/arm_right").show()
		get_node("rotate/character_sprites/base/body/arm_left").show()
		move(0, player_acceleraction_ground, delta)
		anim = "base"
		anim_speed = 2.0
		anim_blend = 0.2
	
	rotate_behavior()
	
	if is_on_ground():
		if btn_jump.check() == 1:
			#print("jump")
			set_axis_velocity(Vector2(0,-player_jump_height))
		elif btn_z.check() == 1:
			if CHARASTATE != "blue" or true:
				move(0, player_acceleraction_ground, delta)
				anim = "attack_1_in"
				PLAYERSTATE_NEXT = "attack"
				CHARASTATE_NEXT = "green_attack"
				anim_speed = 2.0
				anim_blend = 0.2
				GOTO_NEXT = "stay"
				
				raycast_left0.set_enabled(true)
				raycast_left1.set_enabled(false)
				
				
				get_node("CollisionShape2D 2").set_trigger(false)
				get_node("CollisionShape2D").set_trigger(true)
			else:
				pass
			
			
			
	else:
		PLAYERSTATE_NEXT = "air"


func air_state(delta):
	if btn_left.check() == 2:
		move(-player_speed, player_acceleraction_air, delta)
		ORIENTATION_NEXT = "left"
	elif btn_right.check() == 2:
		move(player_speed, player_acceleraction_air, delta)
		ORIENTATION_NEXT = "right"
	else:
		move(0, player_acceleraction_air, delta)
	
	if get_linear_velocity().y > 1:
		anim = "jump_down"
		anim_speed = 1.0
	elif get_linear_velocity().y < -1:
		anim = "jump_up"
		anim_speed = 1.0
		anim_blend = 0.0
	
	rotate_behavior()
	
	if is_on_ground():
		PLAYERSTATE_NEXT = "ground"


func attack_state(delta):
	if is_on_ground():
		
		if btn_z.check() == 1:
			anim = "attack_1_out"
			anim_speed = 2.0
			anim_blend = 0.2
			PLAYERSTATE_NEXT = "ground"
			CHARASTATE_NEXT = "green_normal"
			GOTO = "stay"
			raycast_left0.set_enabled(false)
			raycast_left1.set_enabled(true)
			get_node("CollisionShape2D").set_trigger(false)
			get_node("CollisionShape2D 2").set_trigger(true)
	
	if GOTO == "stay":
		move(0, player_acceleraction_ground, delta)
		
		if btn_left.check() == 1:
			print("left")
			set_linear_velocity(Vector2(-player_attack_speed, get_linear_velocity().y))
			GOTO_NEXT = "left"
			ORIENTATION_NEXT = "left"
		elif btn_right.check() == 1:
			print("right")
			set_linear_velocity(Vector2(player_attack_speed, get_linear_velocity().y))
			GOTO_NEXT = "right"
			ORIENTATION_NEXT = "right"
		
	elif GOTO == "left":
		set_linear_velocity(Vector2(-player_attack_speed, get_linear_velocity().y))
		if counter > 2.0 and raycast_left0.is_colliding():
			counter = 0
			GOTO_NEXT = "right"
			ORIENTATION_NEXT = "right"
	elif GOTO == "right":
		set_linear_velocity(Vector2(player_attack_speed, get_linear_velocity().y))
		if counter > 2.0 and raycast_right0.is_colliding():
			counter = 0
			GOTO_NEXT = "left"
			ORIENTATION_NEXT = "left"
			
	rotate_behavior()
	
func green_normal(delta):
	if raycast_down.is_colliding():
		collion_on = raycast_down.get_collider().get_name()
		if collion_on == "floor":
			PLAYERSTATE_NEXT = "die"
		if collion_on == "Mushroom":
			PLAYERSTATE_NEXT = "die"
		if collion_on == "item":
			CHARASTATE_NEXT = "blue"
			print("blue")
			
	if raycast_left1.is_colliding():
		collion_on = raycast_left1.get_collider().get_name()
		if collion_on == "Mushroom":
			PLAYERSTATE_NEXT = "die"
		if collion_on == "item":
			CHARASTATE_NEXT = "blue"
			print("blue")
	if raycast_right0.is_colliding():
		collion_on = raycast_right0.get_collider().get_name()
		if collion_on == "Mushroom":
			PLAYERSTATE_NEXT = "die"
		if collion_on == "item":
			CHARASTATE_NEXT = "blue"
			print("blue")
	
	collion_on = ""

func green_attack(delta):
	if raycast_down.is_colliding():
		collion_on = raycast_down.get_collider().get_name()
		if collion_on == "floor":
			print("dsafsa")
			PLAYERSTATE_NEXT = "die"
	collion_on = ""


###############################################################

func _ready():
	set_mode(2)
	raycast_down = get_node("RayCast_Down")
	raycast_down.add_exception(self)
	rotate = get_node("rotate")
	anim_player = get_node("rotate/character_sprites/AnimationPlayer")
	raycast_right0 = get_node("RayCast_Right0")
	raycast_left0 = get_node("RayCast_Left0")
	raycast_left1 = get_node("RayCast_Left1")
	
	set_fixed_process(true)


func _fixed_process(delta):
	#print(get_linear_velocity())
	
	PLAYERSTATE_PREV = PLAYERSTATE
	PLAYERSTATE = PLAYERSTATE_NEXT
	
	CHARASTATE_PREV = CHARASTATE
	CHARASTATE = CHARASTATE_NEXT
	
	ORIENTATION_PREV = ORIENTATION
	ORIENTATION = ORIENTATION_NEXT
	
	GOTO_PREV = GOTO
	GOTO = GOTO_NEXT
	
	if PLAYERSTATE == "ground":
		ground_state(delta)
	elif PLAYERSTATE == "air":
		air_state(delta)
	elif PLAYERSTATE == "attack":
		attack_state(delta)
	elif PLAYERSTATE == "die":
		set_linear_velocity(Vector2(0, 0))
		anim = "die"
		get_node("die").show()
		
	if CHARASTATE == "green_normal":
		green_normal(delta)
	elif CHARASTATE == "green_attack":
		green_attack(delta)
	elif CHARASTATE == "blue":
		get_node("rotate/character_sprites/base/body/tail").set_texture(get_node("rotate/character_sprites/state_2/body/tail").get_texture())
		get_node("rotate/character_sprites/base/body/arm_left").set_texture(get_node("rotate/character_sprites/state_2/body/arm_left").get_texture())
		get_node("rotate/character_sprites/base/body/arm_right").set_texture(get_node("rotate/character_sprites/state_2/body/arm_right").get_texture())
		get_node("rotate/character_sprites/base/body/head").set_texture(get_node("rotate/character_sprites/state_2/body/head").get_texture())
		get_node("rotate/character_sprites/base/body").set_texture(get_node("rotate/character_sprites/state_2/body").get_texture())
		get_node("rotate/character_sprites/base/body/foot_right").set_texture(get_node("rotate/character_sprites/state_2/body/foot_right").get_texture())
		get_node("rotate/character_sprites/base/body/foot_left").set_texture(get_node("rotate/character_sprites/state_2/body/foot_left").get_texture())
		green_normal(delta)
	
	if anim != anim_new:
		anim_new = anim
		anim_player.play(anim,anim_blend,anim_speed)
		
	counter += 0.1
