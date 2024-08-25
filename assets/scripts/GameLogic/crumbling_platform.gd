extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var tremble_timer: Timer = $TrembleTimer
@onready var respawn_timer: Timer = $RespawnTimer
@onready var crumbling = $crumbling

# moves the animation to compensate for irregular height during idling stat but constant height during trembling animation
var animation_offset: float = 5.0
# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("idle")


func _physics_process(delta):
	# check for feet collision with player
	var bodies = get_overlapping_bodies()
	for body in bodies: 
		if body is Player:
			var children: Array[Node] = body.get_children()
			for child in children: 
				if child.name == "FeetCollision" and body.is_on_floor:
					self.set_position(Vector2(self.get_position().x, self.get_position().y + animation_offset)) 
					set_physics_process(false)
					animation_player.play("tremble")
					tremble_timer.start()


func _on_tremble_timer_timeout():
	self.set_position(Vector2(self.get_position().x, self.get_position().y - animation_offset))
	crumbling.play()
	animation_player.play("fall")


func _on_animation_player_animation_finished_fall(anim_name):
	respawn_timer.start()


func _on_respawn_timer_timeout():
	self.set_position(Vector2(self.get_position().x, self.get_position().y - animation_offset))
	set_physics_process(true)
	animation_player.play("idle")
