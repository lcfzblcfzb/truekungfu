extends AudioStreamPlayer2D

var looping =false

func _on_FightActionMng_ActionStart(action:ActionInfo):
	#动画播放时长
	var action_time = action.action_duration_ms/1000.0
	var base_action =action.get_base_action()
	var action_key = base_action.sound_effect_key * action_time
	
	looping=false
	if base_action.sound_effects.size()<=0:
		stop()
		return
		
	var sound_cfg = GlobVar.SoundResrouceConfigs.get_by_id(Glob.RandomTool.get_random(base_action.sound_effects))
	if sound_cfg:
		var sound_key = sound_cfg.key_frame_time
		var sound_res = sound_cfg.sound_res
		
		stream = sound_res
		if action_key> sound_key:
			#wait
			yield(get_tree().create_timer(action_key-sound_key),"timeout")
			play()
		elif action_key ==sound_key:
			play()
		elif action_key< sound_key:
			play(sound_key-action_key)
		
		if action.action_duration_ms<0:
			looping =true
	else:
		stop()
	
func _on_AudioStreamPlayer2D_finished():
	if looping:
		play()
	else:
		stop()
