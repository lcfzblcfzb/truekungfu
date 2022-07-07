extends Control

#每行最大数量
export(int) var max_column_size = 4
#外层的间距
const Margin = 2
#
const UI_Item = preload("res://FrameWork/UI/interface/UI_Items.tscn")

onready var row_container =$VBoxContainer

var inventory:Inventory
#item : index->item
var item_slots ={}

func _ready():
	for h_containter in row_container.get_children():
		for child in h_containter.get_children():
			item_slots[child.index] = child
			
			child.set_drag_forwarding(self)

func bind_inventory(p_inventory:Inventory):
	inventory = p_inventory
	
	inventory.connect("OutfitAdded",self,"on_outfit_change")
	inventory.connect("OutfitDeleted",self,"on_outfit_change")
	inventory.connect("OutfitChanged",self,"on_outfit_change")
	inventory.connect("OutfitSwitched",self,"on_outfit_switched")
	
func display():
	
	for index in inventory.slot_id_outfit:
		var outfit =inventory.get_by_index(index)
		if outfit==null:
			item_slots[index].remove_outfit()
			continue
		item_slots[index].add_outfit(outfit)

func on_outfit_switched(a,b):
	display()
	
func on_outfit_change(outfit):
	display()
	
func get_drag_data_fw(_pos,from_control):
	print(from_control.index)
	
	var texture_rect = TextureRect.new()
	texture_rect.texture= from_control.get_preview_texture()
	set_drag_preview(texture_rect)
	return from_control

func can_drop_data_fw(_pos, data ,from_control):
	return data is Control and data["index"]!=null and data != from_control and from_control.outfit==null

func drop_data_fw(_pos, data ,from_control):
	
	inventory.switch_slot(data["index"],from_control["index"])
	

