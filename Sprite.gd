extends Sprite


func _ready():
	material.set_shader_param("nb_frames",Vector2(hframes, vframes))

var p;
func _process(delta):
	p =get_parent()
	material.set_shader_param("frame_coords",frame_coords)
	material.set_shader_param("velocity",Vector2.ZERO)
