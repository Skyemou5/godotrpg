extends Node2D


func CreateGrassEffect():
	var GrassEffect = load("res://Effects/GrassEffect.tscn")
	var _grassEfect = GrassEffect.instance()
	var world = get_tree().current_scene
	world.add_child(_grassEfect)
	_grassEfect.global_position = global_position

func _on_HurtBox_area_entered(area):
	CreateGrassEffect()
	queue_free()
