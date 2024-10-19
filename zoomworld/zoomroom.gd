@tool
extends Node2D
class_name ZoomRoom
@export var font : Font
func _draw() -> void:
	if Engine.is_editor_hint():
		draw_rect(Rect2(-5,-5,110,110), Color(1,1,1,0.1), false, 10)
		draw_rect(Rect2(-1,-1,102,102), Color(1,0,1), false, 1)
		if font: draw_string(font, Vector2(0,-10), name)
