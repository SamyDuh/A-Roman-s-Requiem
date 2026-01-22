extends "res://Scripts/Weapons/human_weapon.gd"

func _weapon_start():
	var attack_tween = create_tween()
	attack_tween.set_loops()
	
	attack_tween.tween_property(get_parent(),"rotation",deg_to_rad(70),.3)
	attack_tween.tween_property(get_parent(),"rotation",deg_to_rad(-70),.3)
