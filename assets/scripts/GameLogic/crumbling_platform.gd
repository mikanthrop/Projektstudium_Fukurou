extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var tremble_timer: Timer = $TrembleTimer
@onready var respawn_timer: Timer = $RespawnTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("idle")


func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies: 
		if body.name == "Player":
			set_physics_process(false)
			animation_player.play("tremble")
			tremble_timer.start()
		else: 
			animation_player.play("idle")


func _on_tremble_timer_timeout():
	animation_player.play("fall")


func _on_animation_player_animation_finished_fall(anim_name):
	respawn_timer.start()


func _on_respawn_timer_timeout():
	set_physics_process(true)
	animation_player.play("idle")
