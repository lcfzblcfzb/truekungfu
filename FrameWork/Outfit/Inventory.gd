class_name Inventory

signal OutfitAdded(outfit)
signal OutfitDeleted(outfit)
signal OutfitChanged(outfit)
signal OutfitSwitched(idx_from,idx_to)

var host

var slot_num=0

var slot_id_outfit ={}

func init(host,max_slot):
	slot_num = max_slot
	for i in max_slot:
		slot_id_outfit[i]=null

func get_by_index(idx):
	return slot_id_outfit.get(idx)

func _get_available_slot()->int:
	
	var result = -1
	for id in slot_id_outfit.keys():
		
		if slot_id_outfit[id]==null:
			result = id
			break
	
	return result

func add_outfit(of):
	
	var slot_id = _get_available_slot()
	if slot_id<0:
		return
	
	add(slot_id,of)

func switch_slot(from_idx,to_idx):
	
	if from_idx==to_idx:
		return
	var from_of = slot_id_outfit.get(from_idx)
	var to_of = slot_id_outfit.get(to_idx)
	slot_id_outfit[from_idx] = to_of
	slot_id_outfit[to_idx] = from_of
	
	emit_signal("OutfitSwitched",from_idx,to_idx)

func add(slot_id ,of:Outfit):
	if slot_id_outfit.get(slot_id)!=null:
		return
	slot_id_outfit[slot_id] = of
	emit_signal("OutfitAdded",of)
	
func delete(id):
	var result = slot_id_outfit.erase(id)
	emit_signal("OutfitDeleted",id)
	return result
	
func use(id):
	slot_id_outfit[id].on_used()
	pass
