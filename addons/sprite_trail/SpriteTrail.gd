tool
extends Node2D

# Author: Luiz Lopes (youtube.com/CanalPalco)
# License: MIT
#
# Add a trail of copies of the parent's texture.
#
# Usage: put as a child of Sprite or Animated Sprite and tweek the settings in
# the inspector.
#
# Implementation
# The `_trail_copies` variable has information about the copies as dictionaries
# in the following format:
# {
#     global_position, # (Vector2) The global position of this copy
#     texture, # (Texture) A reference to the texture used in this copy
#     remaining_time, # (float) Remaining time until it disappears
#     transform_scale, # (Vector2) x = -1 if flip_h and y = -1 if flip_v, else both = 1
# }
#
# This works by using `draw_texture` method to draw copies of the parent's
# texture. If it is an AnimatedSprite it records the current frame's texture.
# There is a problem when flipping the sprite, the flipping doesn't occur when
# calling `draw_texture`. So there is a work-arround setting the draw_scale as
# -1 and then correcting the positions for the new transform.

enum ProcessMode {PROCESS, PHYSICS_PROCESS}

export var active: = false setget set_active
export var life_time: = 0.6
export var fake_velocity: = Vector2(0, 0)
export var copy_period: = 0.2
export var gradient: Gradient
export var behind_parent: = true setget set_behind_parent
export (ProcessMode) var process_mode: int = ProcessMode.PROCESS setget set_process_mode

var _trail_copies: = []
var _elapsed_time: = 0.0


func _ready() -> void:
	show_behind_parent = behind_parent
	set_process_mode(process_mode)


func _process(delta: float) -> void:
	update_trail(delta, get_parent())


func _physics_process(delta: float) -> void:
	update_trail(delta, get_parent())


func _draw() -> void:
	for i in _trail_copies.size():
		var copy: Dictionary = _trail_copies[i]
		# We need to correct the direction if the scale is set to -1, see
		# spawn_copy method.
		var draw_translation: Vector2 = (to_local(copy.global_position) + get_parent().offset) * copy.transform_scale
		if get_parent().centered:
			draw_translation -= copy.texture.get_size() / 2.0

		var draw_transform = Transform2D(0.0, Vector2()) \
			.scaled(copy.transform_scale) \
			.translated(draw_translation)

		draw_set_transform_matrix(draw_transform)
		
		if copy.has("f"):
			var w = copy.texture.get_width()
			var h = copy.texture.get_height()
			var width = w / copy.hf
			var height =h/copy.vf 
			
			var x =copy.f % copy.hf * width;
			var y =int(copy.f / copy.hf) * height;
			draw_texture_rect_region(copy.texture,Rect2(width*(copy.hf-1) /2,height*(copy.vf-1) /2,width,height),Rect2(x,y,width,height),calculate_copy_color(copy))
			#draw_texture_rect_region(copy.texture,Rect2(width*(copy.hf-1)/2,height,width,height),Rect2(x,y,width,height),calculate_copy_color(copy))
			#draw_texture_rect(copy.texture,Rect2(64,0,w,h),false,calculate_copy_color(copy),false)
			#draw_texture_rect(copy.texture,Rect2(0,0,width,height),false,calculate_copy_color(copy),false)
			pass
		else:
			draw_texture(
				copy.texture,
				Vector2(),
				calculate_copy_color(copy)
			)


func process_copies(delta: float) -> void:
	var empty_copies: = _trail_copies.empty()

	for copy in _trail_copies:
		copy.remaining_time -= delta

		if copy.remaining_time <= 0:
			_trail_copies.erase(copy)
			continue

		copy.global_position -= fake_velocity * delta

	if not empty_copies:
		update()


func get_texture(sprite: Node2D) -> Texture:
	if sprite is Sprite:
		var t = sprite.texture
		return sprite.texture
	elif sprite is AnimatedSprite:
		return sprite.frames.get_frame(sprite.animation, sprite.frame)
	else:
		push_error("The SpriteTrail has to have a Sprite or an AnimatedSpriet as parent.")
		set_active(false)
		return null


func calculate_copy_color(copy: Dictionary) -> Color:
	if gradient:
		return gradient.interpolate(range_lerp(copy.remaining_time, 0, life_time, 0, 1))

	return Color(1, 1, 1)


func spawn_copy(delta: int, parent: Node2D) -> void:
	var copy_texture: = get_texture(parent)
	var copy_position: Vector2

	if not copy_texture:
		return

	if parent.centered:
		copy_position = parent.global_position
	else:
		copy_position = parent.global_position

	# This is needed because the draw transform's scale is set to -1 on the flip
	# direction when the sprite is flipped
	var transform_scale: = Vector2(1, 1)
	if parent.flip_h:
		transform_scale.x = -1
	if parent.flip_v:
		transform_scale.y = -1

	var trail_copy: = {
		global_position = copy_position,
		texture = copy_texture,
		remaining_time = life_time,
		transform_scale = transform_scale,
	}
	
	if parent is Sprite:
		var hf =parent.hframes
		var vf = parent.vframes
		var f = parent.frame
		trail_copy.hf = hf
		trail_copy.vf = vf
		trail_copy.f = f
	_trail_copies.append(trail_copy)


func update_trail(delta: float, parent: Node2D) -> void:
	if active:
		_elapsed_time += delta

	process_copies(delta)

	if _elapsed_time > copy_period and active:
		spawn_copy(delta, parent)
		_elapsed_time = 0.0


func set_active(value: bool) -> void:
	active = value


func set_behind_parent(value: bool) -> void:
	behind_parent = value
	show_behind_parent = behind_parent


func set_process_mode(value: int) -> void:
	process_mode = value

	set_process(process_mode == ProcessMode.PROCESS)
	set_physics_process(process_mode == ProcessMode.PHYSICS_PROCESS)


func _get_configuration_warning() -> String:
	if not (get_parent() is Sprite or get_parent() is AnimatedSprite):
		return "This node has to be a child of a Sprite or an Animated Sprite to work."

	return ""
