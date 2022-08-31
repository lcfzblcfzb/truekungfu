extends Node2D

const EnhancedAudioStreamPlayer2D =preload("res://FrameWork/Sound/EnhancedAudioStreamPlayer2D.gd")

var channel_dict={}

func new_sound(audio,channel,bus="Effect"):
	
	if channel_dict.has(channel):
		
		var audio_player =get_channel(channel) as EnhancedAudioStreamPlayer2D
		audio_player.stream = audio
		return audio_player
	else:
		
		var audio_player = EnhancedAudioStreamPlayer2D.new()
		audio_player.bus = bus
		channel_dict[channel] = audio_player
		audio_player.stream = audio
		add_child(audio_player)
		return audio_player
	
func get_channel(channel):
	return channel_dict.get(channel)
