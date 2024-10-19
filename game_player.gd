extends Node2D
class_name GamePlayer
var game_screen : GameScreen = null
#var is_active :
	#get() : return game_screen != null and game_screen.is_active

func get_yes_hit() -> bool : return Input.is_action_just_pressed("yes")
func get_yes_held() -> bool : return Input.is_action_pressed("yes")
func get_no_hit() -> bool : return Input.is_action_just_pressed("no")
func get_no_held() -> bool : return Input.is_action_pressed("no")
func get_dpad() -> Vector2i :
	return Vector2i(
		1 if Input.is_action_pressed("right") else 0 - 1 if Input.is_action_pressed("left") else 0 ,
		1 if Input.is_action_pressed("down") else 0 - 1 if Input.is_action_pressed("up") else 0 )
func get_dpad_norm() -> Vector2 :
	return Vector2(
		1 if Input.is_action_pressed("right") else 0 - 1 if Input.is_action_pressed("left") else 0 ,
		1 if Input.is_action_pressed("down") else 0 - 1 if Input.is_action_pressed("up") else 0
	).normalized()
func get_dpad_hit() -> Vector2i :
	return Vector2i(
		1 if Input.is_action_just_pressed("right") else 0 - 1 if Input.is_action_just_pressed("left") else 0 ,
		1 if Input.is_action_just_pressed("down") else 0 - 1 if Input.is_action_just_pressed("up") else 0 )
