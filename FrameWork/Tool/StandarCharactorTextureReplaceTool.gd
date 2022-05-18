tool
extends Sprite

export(String, DIR) var texture_folder :String setget set_texture_folder
export(bool) var modifying =false

func _ready():
	if texture_folder and not texture_folder.empty():
		casacade_set_texture(self)	
		
	
#	cascade_set_null(self)6
	pass # Replace with function body.

func set_texture_folder(t):
	
	texture_folder = t
	if self.name !="":
		casacade_set_texture(self)

func casacade_set_texture(node:Sprite):
	var fn = texture_folder+"/"+node.name+".tres"
	node.texture = load(fn)
	
	for child in node.get_children():
		if child is Sprite:
			var cc = child
			print(cc)
			casacade_set_texture(child)
		else:
			continue
	pass

func cascade_set_null(node:Sprite):
	node.texture = null
	
	for child in node.get_children():
		cascade_set_null(child)
	
	pass
