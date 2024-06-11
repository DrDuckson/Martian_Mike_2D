extends Node2D

@export var next_level: PackedScene = null
@export var level_time = 120
@export var is_final_level: bool = false

@onready var start_zone = $StartZone
@onready var exit = $Exit
@onready var deathzone = $Deathzone
@onready var hud = $UI_Layer/HUD
@onready var ui_layer = $UI_Layer


var player = null
var timer_node = null
var time_left
var win = false

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
	exit.body_entered.connect(_on_exit_body_entered)
	deathzone.body_entered.connect(_on_deathzone_body_entered)
	levelTimer()
	ui_layer.show_start_menu(false)
	
func levelTimer():
	time_left = level_time
	hud.set_time_label(time_left)
	timer_node = Timer.new()
	timer_node.name = "Level_Timer"
	timer_node.wait_time = 1
	timer_node.timeout.connect(_on_level_timer_timeout)
	add_child(timer_node)
	timer_node.start()
	
func _on_level_timer_timeout():
	if win == false:
		time_left -= 1
		hud.set_time_label(time_left)
		if time_left < 0:
			reset_player()
			time_left = level_time
			hud.set_time_label(time_left)

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
	AudioPlayer.play_sfx("hurt")
	player.velocity = Vector2.ZERO
	player.global_position = start_zone.get_spawn_pos()

func _on_exit_body_entered(body):
	if body is Player:
		if is_final_level || (next_level != null):
			exit.animate()
			player.active = false
			win = true
			await get_tree().create_timer(2).timeout
			if is_final_level:
				ui_layer.show_win_screen(true)
			else:
				get_tree().change_scene_to_packed(next_level)
