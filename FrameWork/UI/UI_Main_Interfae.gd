extends Control

onready var UI_frame = $UI_Frame
onready var UI_inventory = $InventoryPopup/UI_Inventory
onready var UI_inventory_popup =$InventoryPopup

#inventory
func bind_inventory(inventory:Inventory):
	UI_inventory.bind_inventory(inventory)

func open_inventory():
	UI_inventory.display()
	UI_inventory_popup.popup_centered()
