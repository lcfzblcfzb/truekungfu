class_name BaseGear
extends Resource

export (Glob.GearEnum) var id = Glob.GearEnum.DaoshiCloth
export (String) var name
export (String) var desc
export (Texture) var icon
export (Glob.GearSlot) var slot
export (Glob.BaseOutfitType) var baseOutfitId

export (PackedScene) var scene

export(Array,Resource) var gear_parts
