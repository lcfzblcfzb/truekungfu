extends "res://FrameWork/Sound/SoundMng.gd"

func _on_FightActionMng_ActionStart(action:ActionInfo):
	#动画播放时长
	var action_time = action.action_duration_ms/1000.0
	var base_action =action.get_base_action()
	var action_key = base_action.sound_effect_key * action_time
	
	var looping=false
	if base_action.sound_effects.size()<=0:
		
		var audio_player = get_channel(base_action.sound_channel)
		if audio_player:
			audio_player.stop()
		return
	
	var sound_cfg = GlobVar.SoundResrouceConfigs.get_by_id(Glob.RandomTool.get_random(base_action.sound_effects))
	if sound_cfg:
		var sound_key = sound_cfg.key_frame_time
		var sound_res = sound_cfg.sound_res
		if sound_res==null:
			print(base_action)
		var audio_player = new_sound(sound_res,base_action.sound_channel)
		
		if action.action_duration_ms<0:
			audio_player.looping =true
		else:
			audio_player.looping =false
			
		var stream = sound_res
		if action_key> sound_key:
			#wait
			yield(get_tree().create_timer(action_key-sound_key),"timeout")
			audio_player.play()
		elif action_key ==sound_key:
			audio_player.play()
		elif action_key< sound_key:
			audio_player.play(sound_key-action_key)
		
	else:
		
		var audio_player = get_channel(base_action.sound_channel)
		if audio_player:
			audio_player.stop()
	
