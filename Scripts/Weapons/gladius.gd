extends "res://Scripts/Weapons/human_weapon.gd"

func _weapon_start():
	var attack_tween = create_tween()
	attack_tween.set_loops()
	
	attack_tween.set_ease(Tween.EASE_IN_OUT)
	attack_tween.set_trans(Tween.TRANS_SINE)
	attack_tween.tween_property(get_parent(),"rotation",deg_to_rad(70),.3)
	attack_tween.tween_property(get_parent(),"rotation",deg_to_rad(-70),.3)
