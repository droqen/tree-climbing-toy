extends Camera2D

@export var player : Node2D
func _physics_process(_delta: float) -> void:
	position = 110 * Vector2i(
		int(floor((player.position.x+5)/110.0)),
		int(floor((player.position.y+5)/110.0))
	)
