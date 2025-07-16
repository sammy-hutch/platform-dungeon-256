extends Area2D

var teleporter_id: String = "default_teleporter"

signal player_entered_teleporter(body: CharacterBody2D, teleporter_id: String)

func _ready():
	connect("player_entered_teleporter", _on_player_entered_teleporter)
	print("successfully connected teleporter")

# func _on_player_entered_teleporter(body: CharacterBody2D, teleporter_id: String) -> void:
	# if body.is_in_group("player"):
	# print("Player entered teleporter")
	# body.get_node("CollisionShape2D").queue_free()
	# get_tree().reload_current_scene()
	# player_entered_teleporter.emit(body, teleporter_id)

func _on_player_entered_teleporter(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Player entered teleporter")
		player_entered_teleporter.emit(teleporter_id)
