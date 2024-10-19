extends GamePlayer

@export var body : RigidBody2D

func _ready() -> void:
	game_screen = $"../.."
	body.inertia = 9999

func _physics_process(_delta: float) -> void:
	body.angular_velocity = -body.rotation
	if game_screen and game_screen.is_active:
		if not $Sprite2D.visible:
			var p = get_parent()
			p.remove_child(self)
			position = $cursor_parent/cursor.position + 6*game_screen.enterdir + Vector2(0,3)
			p.add_child(self)
			$Sprite2D.show()
		body.linear_velocity = get_dpad_norm() * 50
		$cursor_parent/cursor.hide()
		if game_screen: game_screen.main.treename = ''
		
		for tree_area in $treefinder.get_overlapping_areas():
			var tree = tree_area.get_parent() # treeportal
			game_screen.exitdir = (global_position - tree.global_position).normalized()
			$cursor_parent/cursor.position = tree.global_position
			$cursor_parent/cursor.show()
			if game_screen: game_screen.main.treename = tree.name
			break;
	else:
		body.linear_velocity = Vector2.ZERO
		$Sprite2D.hide()
