extends Path2D

# variables for the main scene
## [float] value. Determines how fast the platform is moving in seconds. \b 
## Speed is dependant on the length of the curves. So 2.0 seconds for long curves is quite fast but 2.0 for short curves is very slow. \b
## Speed can be a negative value, which results in the platform moving into the opposite direction the curve is using.  
@export var speed: float = 2.0
## [[float]] value. Determines how long the platform is standing still on either side of the loop. 
@export var float_duration: float = 3.0
## [[bool]] value. Determines if platform is looping or not. 
@export var loop: bool = true

# needed nodes
@onready var path: PathFollow2D = $PathFollow2D
@onready var timer: Timer = $FloatTimer
@onready var collision_shape: CollisionShape2D = $AnimatableBody2D/CollisionShape2D

# logic variables
var approximate_beginning: float = 0.02
var approximate_ending: float = 0.98
var offset: float = 0.01

# flags
var timer_started: bool = false
var movement_paused: bool = false
var upward_movement: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# check if curve is empty
	if curve == null: 
		push_error("curve of ", self.name, " is empty.")
	
	#give timer float_duration
	timer.wait_time = float_duration
	
	#if not loop: 
		#animation.play("move")
		#animation.speed_scale = speed_scale
		#set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# 
	if (not timer_started):
		if (path.get_progress_ratio() > approximate_ending):
			timer.start()
			timer_started = true
			movement_paused = true
		elif (path.get_progress_ratio() < approximate_beginning):
			timer.start()
			timer_started = true
			movement_paused = true
	if (not movement_paused and loop):
		if (upward_movement):  # Move upwards
			path.set_progress_ratio(path.get_progress_ratio() + speed * delta)
		else:  # Move downwards
			path.set_progress_ratio(path.get_progress_ratio() - speed * delta)
	if (not movement_paused and not loop):
		path.set_progress_ratio(path.get_progress_ratio() + speed * delta)
	# let player fall off the oneshot platform at the end of its curve 
	if (movement_paused and not loop and path.get_progress_ratio() > approximate_ending):
		await timer.timeout
		collision_shape.set_deferred("disabled", true)
		collision_shape.set_deferred("disabled", false)


func _on_float_timer_timeout() -> void:
	timer_started = false
	movement_paused = false
	if (path.get_progress_ratio() <= approximate_beginning):
		upward_movement = true
		path.set_progress_ratio(approximate_beginning+offset)
	elif (path.get_progress_ratio() >= approximate_ending):
		upward_movement = false
		path.set_progress_ratio(approximate_ending-offset)
