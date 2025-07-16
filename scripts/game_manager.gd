extends Node

var levelCounter = 0
var level = preload("res://scenes/level.tscn")

@onready var level_node: Node2D = $Level
@onready var player: CharacterBody2D = $Player

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
	var level2 = preload("res://scenes/level2.tscn")
	if level2:
		var current_level2 = level2.instantiate()
		if level_node and level_node.get_parent():
			level_node.queue_free()
		add_child(current_level2)
		level_node = current_level2
		
		var teleporter_node = level_node.get_node("Teleporter")
		if teleporter_node:
			print("teleporter identified")
		if teleporter_node and teleporter_node.has_signal("player_entered_teleporter"):
			teleporter_node.player_entered_teleporter.connect(_on_teleporter_player_entered)
			print("GameManager connected to teleporter's signal")
		
		player.position = Vector2(0, 0)
		
		print("new level loaded")
	else:
		print("Failed to load next level scene.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
