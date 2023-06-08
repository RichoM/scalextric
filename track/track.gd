extends Spatial
tool

var is_dirty = true

onready var path := $path

export var track_width := 20.0 setget set_track_width
func set_track_width(val):
	if val == track_width: return
	track_width = val
	force_update()

func _ready():
	force_update()

func force_update():
	is_dirty = true
	call_deferred("update")
	
func update():
	if !is_dirty: return
	is_dirty = false
	
	update_road()
			
func update_road():
	var road : CSGPolygon = $path/road
	if !road: return
	var x = track_width/2
	var y = 0.12
	var points = [Vector2(-x, 0), Vector2(-x, y),Vector2(x,y), Vector2(x, 0)]
	road.polygon = PoolVector2Array(points)

func _on_path_curve_changed():
	force_update()
