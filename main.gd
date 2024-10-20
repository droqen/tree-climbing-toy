extends Control

enum {
	MODE_UNDEFINED,
	MODE_PAUSED,
	MODE_OVERWORLD,
	MODE_ZOOMWORLD,
}

var worldmode = MODE_UNDEFINED
func set_worldmode(v) -> bool:
	if worldmode != v:
		worldmode = v
		overw_outline_colorrect.call('show' if v==MODE_OVERWORLD else 'hide')
		zoomw_outline_colorrect.call('show' if v==MODE_ZOOMWORLD else 'hide')
		overw_game.set_game_active(v==MODE_OVERWORLD)
		zoomw_game.set_game_active(v==MODE_ZOOMWORLD)
		return true
	return false;

@onready var overw_outline_colorrect : ColorRect = $overw/outlinem/c
@onready var overw_viewport : Viewport = $overw/viewcont/view
@onready var overw_game : GameScreen = $overw/viewcont/view/Overgame
@onready var zoomw_outline_colorrect : ColorRect = $zoomw/outlinem/c
@onready var zoomw_viewport : Viewport = $zoomw/viewcont/view
@onready var zoomw_game : ZoomGameScreen = $zoomw/viewcont/view/Zoomgame

@export var tree_collection_packed : PackedScene
@onready var tree_collection : Node = tree_collection_packed.instantiate()
var treename : String = ''
var treenode : ZoomRoom = null

func _ready() -> void:
	overw_game.main = self
	zoomw_game.main = self
	set_worldmode(MODE_OVERWORLD)

func _physics_process(_delta: float) -> void:
	
	# 100x100
	var minratiox : int = 220
	var minratioy : int = 120
	var scaletime : int = mini( size.x / minratiox, size.y / minratioy )
	$overw.size = Vector2i.ONE * scaletime * 100
	$zoomw.size = Vector2i.ONE * scaletime * 100
	overw_viewport.get_parent().stretch_shrink = scaletime
	zoomw_viewport.get_parent().stretch_shrink = scaletime
	$overw.position = Vector2i(size.x/4-50*scaletime, size.y/2 - 50*scaletime)
	$zoomw.position = Vector2i(size.x*3/4-50*scaletime, size.y/2 - 50*scaletime)
	
	match worldmode:
		MODE_OVERWORLD:
			overw_game.modulate.a = lerp(overw_game.modulate.a, 1.00, 0.05)
		_:
			overw_game.modulate.a = lerp(overw_game.modulate.a, 0.25, 0.03)

	
	if treenode != null and treenode.name != treename:
		zoomw_game.set_treeroom(null)
		treenode = null # boop
	if treenode == null and treename != '':
		var source_treenode = tree_collection.get_node_or_null(treename)
		if source_treenode == null:
			treename = ''
		else:
			treenode = source_treenode.duplicate()
			zoomw_game.set_treeroom(treenode)
	
	#if !zoomw_game.noroom and worldmode == MODE_OVERWORLD and Input.is_action_just_pressed("yes"):
	if !zoomw_game.noroom and worldmode == MODE_OVERWORLD and overw_game.exitdir:
		zoomw_game.enterdir = overw_game.exitdir
		set_worldmode(MODE_ZOOMWORLD)
	
func zoom_leave(xdir : int) -> void:
	if worldmode == MODE_ZOOMWORLD:
		overw_game.enterdir = Vector2(xdir, 0)
		set_worldmode(MODE_OVERWORLD)
