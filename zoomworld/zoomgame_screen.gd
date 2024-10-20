extends GameScreen
class_name ZoomGameScreen

const TREECLIMBER_PREFAB = preload("res://zoomworld/treeclimber.tscn")
var player : GamePlayer = null
@onready var camera = $Camera2D
var camvely : float = 0.0
var camgrounded : bool = true

func _ready() -> void:
	for child in $Roomholder.get_children():
		$Roomholder.remove_child(child)
	set_treeroom(null)
	$dither.hide()
	modulate.a = 0.00
	
var noroom : bool = true

func _physics_process(_delta: float) -> void:
	
	if player:
		if player.position.x < 0:
			main.zoom_leave(-1)
		elif player.position.x >= 100:
			main.zoom_leave(1)
		if player.position.y > 100: camgrounded = false
		if player.position.y < 8: camgrounded = false
		if player.position.y > 50 and player.position.y <= 96:
			camgrounded = true
	else:
		camgrounded = true
	
	if camgrounded:
		camvely = lerp(camvely, -camera.position.y * 0.05, 0.15)
		camera.position.y += camvely
	else:
		camvely = lerp(camvely, (player.position.y-50-camera.position.y) * 0.05, 0.1)
		camera.position.y += camvely
	
	if is_active and player==null:
		player = TREECLIMBER_PREFAB.instantiate()
		if enterdir.x < 0: player.position.x = 99
		if enterdir.x > 0: player.position.x = 2
		add_child(player)
		player.owner = owner if owner else self
	if !is_active and player!=null:
		remove_child(player)
		player=null # byee
	
	var goal : float = 0.25
	var rate : float = 0.01
	if is_active: goal = 1.00; rate= 0.13;
	elif !noroom: goal = 0.75; rate= 0.07
	elif modulate.a == 0: rate = 0.00
	modulate.a = lerp(modulate.a, goal, rate)

func set_treeroom(room : ZoomRoom) -> void:
	if room == null:
		if not noroom:
			noroom = true
			# add moire
	else:
		noroom = false
		for child in $Roomholder.get_children():
			if child == room: room = null; continue; # keep the child
			$Roomholder.remove_child(child)
		
		if room:
			room.position = Vector2.ZERO
			$Roomholder.add_child(room)
