extends Control


func _ready():
	PlayerUI.set_item_visible(false)
	%AnimationPlayer.play("fly_in")


func _on_animation_player_animation_finished(anim_name):
	if (anim_name == "fly_in"):
		queue_free()
