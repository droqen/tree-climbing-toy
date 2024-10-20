extends GamePlayer

@export var body : RigidBody2D
@onready var spr : Sprite2D = $Sprite2D

var florbuf : int = 0
var jumpbuf : int = 0
var sitbuf : int = 0

var subani : int = 0
var ani : int = 0

var stammax : float = 1.0
var stamcur : float = 1.0

var default_gravity_scale : float

func _ready() -> void:
	body.inertia = 10
	default_gravity_scale = body.gravity_scale

func _physics_process(delta: float) -> void:
	
	stammax = clampf(stammax,0.0,1.0)
	stamcur = clampf(stamcur,0.0,stammax)
	
	if stamcur >= 1.0:
		$stam.hide()
	else:
		$stam.show()
		$stam/bg.scale.x = stammax
		$stam/fg.scale.x = stamcur
	
	var dx : int = get_dpad().x
	if dx : spr.flip_h = dx>0
	
	#var climbing : bool = get_yes_held() and $climb_area_finder.get_overlapping_bodies()
	var climbing : bool = !$climb_area_finder.get_overlapping_bodies().is_empty()
	var sitting : bool = (not climbing
		and !$sit.get_overlapping_bodies().is_empty()
		and get_dpad().x == 0 and get_dpad().y <= 0)
	
	if sitbuf > 0: sitbuf -= 1
	if sitting:
		if sitbuf == 0: subani = -30; ani = 0;
		sitbuf = 4
	elif subani < 0: subani = 1
	
	if florbuf > 0:
		stammax += 0.5 * delta
		stamcur += 0.5 * delta
	elif sitting:
		stamcur += 0.2 * delta
	
	if sitting:
		body.gravity_scale = 0.0
	else:
		body.gravity_scale = default_gravity_scale
	
	if sitting:
		subani += 1
		if subani > 27: subani = 0; ani = (ani+1) % 4
		spr.frame = [34,35,34,36][ani]
		if stamcur >= stammax:
			stammax += 0.05 * delta
	elif climbing:
		if get_dpad():
			stamcur -= 0.2 * delta
			if stamcur < stammax * 0.5:
				stammax -= 0.05 * delta
			subani += 1
			if subani > 10: subani = 0; ani = (ani+1) % 4
		else:
			stamcur += 0.2 * delta
		spr.frame = [30,31,32,33][ani]
	else:
		if florbuf > 0:
			if get_dpad().x:
				subani += 1
				if subani > 10: subani = 0; ani = (ani+1) % 4
			else:
				subani += 1
				if subani > 10: subani = 0; ani = 0;
		else:
			subani = 0
			ani = 3
		spr.frame = [40,41,42,43][ani]
	
	if sitting:
		body.linear_velocity = Vector2.ZERO
	elif climbing:
		var side_climb_speed : float = lerp( 10.0, 30.0, stamcur)
		var up_climb_speed : float = lerp( 0.0, 30.0, stamcur)
		body.linear_velocity.x = move_toward(body.linear_velocity.x,
			get_dpad_norm().x * side_climb_speed,
			5.0)
		body.linear_velocity.y = move_toward(body.linear_velocity.y * 0.5,
			clamp(get_dpad_norm().y * 30.0, -up_climb_speed, 30.0),
			15.0)
	else:
		body.linear_velocity.x = get_dpad().x * 50.0
	
	#if climbing: jumpbuf = 0
	#elif get_dpad_hit().y < 0: jumpbuf = 4
	#elif jumpbuf > 0: jumpbuf -= 1
	#if jumpbuf>0 and florbuf>0:
		#body.linear_velocity.y = -100 # jump!
		#jumpbuf=0; florbuf=0;
	
	if $floorcast.is_colliding() and body.linear_velocity.y >= 0: florbuf = 6
	elif florbuf > 0: florbuf -= 1
	
	
	subani += 1
