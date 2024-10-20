extends GamePlayer

@export var body : RigidBody2D

func _ready() -> void:
	game_screen = $"../.."
	body.inertia = 9999

var ani : int
var subani : int

var ready_to_enter_dirx : int = 0

func _physics_process(_delta: float) -> void:
	
	var stick : Vector2 = get_dpad_norm()
	
	if stick.y != 0:
		ready_to_enter_dirx = 0
	elif stick.x < 0 and $left_tree.get_overlapping_areas():
		ready_to_enter_dirx = -1
	elif stick.x > 0 and $right_tree.get_overlapping_areas():
		ready_to_enter_dirx = 1
	else:
		ready_to_enter_dirx = 0
	
	game_screen.exitdir = Vector2(0, 0)#(global_position - tree.global_position).normalized()
	
	body.angular_velocity = -body.rotation
	if game_screen and game_screen.is_active:
		if not $Sprite2D.visible:
			var p = get_parent()
			p.remove_child(self)
			position = $cursor_parent/cursor.position + 7*game_screen.enterdir + Vector2(0,1)
			p.add_child(self)
			$Sprite2D.show()
		body.linear_velocity = stick * 39.0
		$cursor_parent/cursor.hide()
		if game_screen: game_screen.main.treename = ''
		
		for tree_area in $treefinder.get_overlapping_areas():
			var tree = tree_area.get_parent() # treeportal
			#game_screen.exitdir = (global_position - tree.global_position).normalized()
			game_screen.exitdir = Vector2(ready_to_enter_dirx, 0)#(global_position - tree.global_position).normalized()
			$cursor_parent/cursor.position = tree.global_position
			$cursor_parent/cursor.show()
			if game_screen: game_screen.main.treename = tree.name
			break;
	else:
		body.linear_velocity = Vector2.ZERO
		$Sprite2D.hide()
	
	if get_dpad():
		subani += 1
		if subani > 10:
			subani = 0
			ani = (ani+1) % 4
	else:
		if ani == 0:
			subani = 8
		else:
			subani += 1
			if subani > 10:
				ani = 0
	$Sprite2D.frame = 40 + ani
