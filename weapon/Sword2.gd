extends Weapon

onready var weaponBox = $sword/weaponBox
onready var audioSteamPlayer =$AudioStreamPlayer

func _ready():
	weaponBox.weapon = self


func _on_AnimationPlayer_animation_finished(anim_name):
	pass # Replace with function body.


func _on_weaponBox_area_entered(area):
	if area is WeaponBox:
		audioSteamPlayer.play(0)
