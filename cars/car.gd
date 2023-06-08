extends Spatial

export var track_path : NodePath

export var speed := 0.0
export var offset := 0.0
export var action := "ui_accept"

export var progress_label : NodePath

var curve : Curve3D
var progress = 0

func _ready():
	curve = get_node(track_path).path.curve
	progress = 0

func _process(delta):
	if curve == null: return
	var pos = curve.interpolate_baked(progress)
	
	if Input.is_action_just_pressed(action):
		speed = 50
	
	progress += speed * delta
	speed *= 0.95
	progress = fposmod(progress, curve.get_baked_length())
	
	transform.origin.x = pos.x
	transform.origin.z = pos.z
	var look_ahead = curve.interpolate_baked(progress + 1)
	look_ahead.y = transform.origin.y
	look_at(look_ahead, Vector3.UP)
#	rotation.x = deg2rad(-20)
	rotation.z = 0
	
	translate_object_local(Vector3.RIGHT * offset)
	
	get_node(progress_label).text =  str(round(100*(progress / curve.get_baked_length()))) + "%"
