extends Node

onready var BGMplayer  = get_node("BGMPlayer")
onready var SFXplayers = get_node("SFXPlayers")

export(int) var sfx_player_count := 8

const MIN_VOLUME := -60.0
const MAX_VOLUME := 0.0

const base_bgm_volume := -10.0 # Db 
const base_sfx_volume := -10.0 # Db 


enum SFX {
	ARC,
}

const SFX_start = {
}

const SFX_array = [
	preload("res://assets/sfx/skills/arc/Swish-NanoChopper.wav"),
]

var bgm_on = true
var bgm_volume = base_bgm_volume
var bgm_linear = 50

var sfx_on = true
var sfx_volume = base_sfx_volume
var sfx_linear = 50



func _ready() -> void:

	set_sfx_player_count(sfx_player_count)

#	BGMplayer.stream = AudioStreamRandomPitch.new()
#	BGMplayer.stream.audio_stream = BGM

	set_sfx_volume(-1)
	set_bgm_volume(10)

#	BGMplayer.play()



func set_bgm_volume(new_value : float) -> void:
	bgm_linear = new_value
	bgm_volume = get_db_equivalent(new_value)
	BGMplayer.volume_db = bgm_volume
#	LOG.pr(3, "Set new BGM volume: (%s), (%s)" % [new_value, bgm_volume])



func set_sfx_volume(new_value : float) -> void:
	sfx_linear = new_value
	sfx_volume = get_db_equivalent(new_value)
	for SFXplayer in SFXplayers.get_children():
		SFXplayer.volume_db = sfx_volume



func play(sfx_id : int) -> void:
	if sfx_on and sfx_id < SFX_array.size():
		for SFXplayer in SFXplayers.get_children():
			if not SFXplayer.is_playing():
#				LOG.pr(3, "PLAYING SFX::(%s)" % [sfx_id])
				SFXplayer.stream.audio_stream = SFX_array[sfx_id]
				SFXplayer.play(SFX_start[sfx_id] if SFX_start.has(sfx_id) else 0)
				break



func get_db_equivalent(val : float) -> float:
	var res = 0.0
	res = inverse_lerp(MIN_VOLUME, MAX_VOLUME, val)
	res = linear2db(res)
	return res




func set_sfx_player_count(count : int) -> void:
	var delta = count - SFXplayers.get_child_count()
#	prints("delta[%s]" % [delta])

	if delta > 0: # Add new
		for _i in range(delta):
			var new_player = AudioStreamPlayer.new()
			new_player.stream = AudioStreamRandomPitch.new()
			SFXplayers.add_child(new_player)
	
	elif delta < 0:
		var sfx_players = SFXplayers.get_children()
		for _i in range(-delta):
			var last = sfx_players.back()
			sfx_players.pop_back()
			
			SFXplayers.remove_child(last)
			last.queue_free()



func _on_BGMPlayer_finished() -> void:
	if bgm_on:
		BGMplayer.play()
