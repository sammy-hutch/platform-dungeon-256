extends Node

var levelCounter = 0
var level = preload("res://scenes/level.tscn")

@onready var level_node: Node2D = $Level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if level_node:
		var teleporter_node = level_node.get_node("Teleporter")
		if teleporter_node:
			print("teleporter identified")
		if teleporter_node and teleporter_node.has_signal("player_entered_teleporter"):
			teleporter_node.player_entered_teleporter.connect(_on_teleporter_player_entered)
			print("GameManager connected to teleporter's signal")
		else:
			print("Error: Teleporter node not found or signal not defined")
	else:
		print("Error: level node not found")
"""
	var current_level = level.instantiate()
	add_child(current_level)
"""
	

func _on_teleporter_player_entered(teleporter_id: String):
	print("triggered")
	print("GameManager received signal from teleporter: %s" % [str(teleporter_id)])
	create_new_level(teleporter_id)

func create_new_level(activated_teleporter_id: String):
	print("Creating new level based on teleporter: %s" % [str(activated_teleporter_id)])
	# Your logic to load a new scene or instantiate a new level goes here.
	# Example:
	# var next_level_scene = load("res://scenes/level_2.tscn")
	# if next_level_scene:
	#     var new_level_instance = next_level_scene.instantiate()
	#     # Remove the old level (if it exists)
	#     if level_node and level_node.get_parent():
	#         level_node.queue_free()
	#     # Add the new level as a child of GameManager
	#     add_child(new_level_instance)
	#     level_node = new_level_instance # Update the reference
	#     print("New level loaded!")
	# else:
	#     print("Failed to load next level scene.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
