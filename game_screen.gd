extends Node2D
class_name GameScreen

var main = null
var is_active : bool = false
var enterdir : Vector2
var exitdir : Vector2
func set_game_active(_active : bool) -> void: is_active = _active;
