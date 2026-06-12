extends Node
class_name veffects

# Utility function for compacting the tween creation process
func _set_tween(loop: bool, ease: Tween.EaseType = Tween.EASE_IN_OUT, trans: Tween.TransitionType = Tween.TRANS_LINEAR) -> Tween:
	var tween = get_tree().create_tween()
	tween.set_ease(ease)
	tween.set_trans(trans)
	if loop: tween.set_loop()
	return tween
