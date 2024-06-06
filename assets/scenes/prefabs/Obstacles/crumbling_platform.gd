extends AnimatableBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var tremble_timer: Timer = $TrembleTimer
@onready var respawn_timer: Timer = $RespawnTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("idle")


func _on_animation_trigger_body_entered(body):
	if body.name == "Player": 
		animation_player.play("tremble")
		print("tremble timer started")
		tremble_timer.start()


func _on_tremble_timer_timeout():
	print("tremble timer timed out")
	animation_player.play("fall")


func _on_animation_player_animation_finished(fall):
	respawn_timer.start()


func _on_respawn_timer_timeout():
	animation_player.play("idle")

