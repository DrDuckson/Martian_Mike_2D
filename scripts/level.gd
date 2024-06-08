extends Node2D

@onready var start_zone = $StartZone
var player = null

func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player != null:
		player.global_position = start_zone.get_spawn_pos()
	var traps = get_tree().get_nodes_in_group("traps")
	for trapIndex in traps:
		#alte methode für "connect signal"
		#trapIndex.connect("touched_player", _on_trap_touched_player)	
		#neue methode
		trapIndex.touched_player.connect(_on_trap_touched_player)

func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func _on_deathzone_body_entered(body):
	reset_player()

func _on_trap_touched_player():
	reset_player()

func reset_player():
	player.velocity = Vector2.ZERO
	player.global_position = start_zone.get_spawn_pos()
