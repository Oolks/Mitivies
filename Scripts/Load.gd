extends Node


func _ready() -> void:
	$AnimationPlayer.play("Load")
	yield(get_tree().create_timer(20), "timeout")
	queue_free()
