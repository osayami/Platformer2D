extends Node2D

@export var next_level : PackedScene = null
@export var level_time = 5
@export var is_final_level: bool = false

@onready var ui_layer: CanvasLayer = $UILayer
@onready var hud = $UILayer/HUD
@onready var start = $Start
@onready var exit: Area2D = $Exit
@onready var death_zone: Area2D = $DeathZone

var player: Player = null
var timer_node = null
var time_left
var win = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if player != null:
		player.global_position = start.get_spawn_position()
	var traps = get_tree().get_nodes_in_group("traps")
	for trap in traps:
		trap.touched_player.connect(_on_trap_touched_player)
	
	exit.body_entered.connect(_on_exit_body_entered)
	death_zone.body_entered.connect(_on_death_zone_body_entered)
	
	time_left = level_time
	hud.set_time_label(time_left)
	timer_node = Timer.new()
	timer_node.name = "LevelTimer"
	timer_node.wait_time = 1
	timer_node.timeout.connect(_on_level_timer_timeout)
	add_child(timer_node)
	timer_node.start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()


func _on_death_zone_body_entered(body: Node2D) -> void:
	AudioPlayer.play_sfx("hurt")
	reset_player()


func _on_trap_touched_player() -> void:
	AudioPlayer.play_sfx("hurt")	
	reset_player()

func reset_player():
	player.velocity = Vector2.ZERO
	player.global_position = start.get_spawn_position()
	time_left = level_time

func _on_exit_body_entered(body):
	if body is Player:
		if is_final_level or (next_level != null):
			exit.animate()
			player.active= false
			win = true
			await get_tree().create_timer(1.5).timeout
			if is_final_level:
				ui_layer.show_win_screen(true)
			else:
				get_tree().change_scene_to_packed(next_level)
		
func _on_level_timer_timeout():
	
	hud.set_time_label(time_left)	
	if win == false:
		time_left -= 1
		if time_left < 0 :
			AudioPlayer.play_sfx("hurt")
			reset_player()
			hud.set_time_label(time_left)
			
