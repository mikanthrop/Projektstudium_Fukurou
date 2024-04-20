extends Path2D

# variables for the main scene
@export var speed: float = 2.0
@export var float_duration: float = 3.0
#@export var loop: bool = true

# needed nodes
@onready var path: PathFollow2D = $PathFollow2D
@onready var timer: Timer = $FloatTimer
#@onready var animation: AnimationPlayer = $AnimationPlayer

# logic variables
var approximate_beginning: float = 0.02
var approximate_ending: float = 0.98
var offset: float = 0.01

var timer_started: bool = false
var movement_paused: bool = false
var upward_movement: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# check if curve is empty
	if curve == null: 
		push_error("curve of a moving platform is empty.")
	
	#give timer float_duration
	timer.wait_time = float_duration
	
	#if not loop: 
		#animation.play("move")
		#animation.speed_scale = speed_scale
		#set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if (not timer_started):
		if (path.get_progress_ratio() > approximate_ending):
			timer.start()
			timer_started = true
			movement_paused = true
			print("moving platform: float timer started")
			print("progress ratio: ", path.get_progress_ratio())
		elif (path.get_progress_ratio() < approximate_beginning):
			timer.start()
			timer_started = true
			movement_paused = true
			print("moving platform: float timer started")
			print("progress ratio: ", path.get_progress_ratio())
	if (not movement_paused):
		if (upward_movement):  # Move upwards
			path.set_progress_ratio(path.get_progress_ratio() + speed * delta)
		else:  # Move downwards
			path.set_progress_ratio(path.get_progress_ratio() - speed * delta)


func _on_float_timer_timeout() -> void:
	print("moving platform float timer timed out")
	timer_started = false
	movement_paused = false
	if (path.get_progress_ratio() <= approximate_beginning):
		upward_movement = true
		path.set_progress_ratio(approximate_beginning+offset)
	elif (path.get_progress_ratio() >= approximate_ending):
		upward_movement = false
		path.set_progress_ratio(approximate_ending-offset)
