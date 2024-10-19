extends GamePlayer

@export var body : RigidBody2D

var florbuf : int = 0
var jumpbuf : int = 0

func _ready() -> void:
	body.inertia = 10

func _physics_process(_delta: float) -> void:
	body.linear_velocity.x = get_dpad().x * 50.0
	
	if get_yes_hit(): jumpbuf = 4
	elif jumpbuf > 0: jumpbuf -= 1
	if jumpbuf>0 and florbuf>0:
		body.linear_velocity.y = -100 # jump!
		jumpbuf=0; florbuf=0;
	
	if $floorcast.is_colliding() and body.linear_velocity.y >= 0: florbuf = 6
	elif florbuf > 0: florbuf -= 1
