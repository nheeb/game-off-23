extends Control


func _ready():
	PlayerUI.set_item_visible(false)
	%AnimationPlayer.play("fly_in",-1,0.75)
	Music.play_victory_track()


func _on_animation_player_animation_finished(anim_name):
	if (anim_name == "fly_in"):
		queue_free()
