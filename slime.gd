extends Area2D

@export var area_size: Vector2 = Vector2(400, 400)  # Movement boundary
@export var speed: float = 50  # Movement speed
@export var move_duration: float = 4.0  # Duration to move before stopping

var direction: Vector2 = Vector2.ZERO
var timer: float = 0.0
var is_moving: bool = false  # Flag to track if slime is moving
var move_timer: float = 0.0  # Timer to track the 4 seconds of movement

func _ready():
	# Initially, slime stays in place
	$AnimatedSprite2D.play("idle")
	direction = Vector2.ZERO

# Detect touch or click on slime
func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		# Check if the touch is inside the slime's collision shape
		if is_touching_slime(event.position):
			start_moving()

func _process(delta):
	#if Input.is_action_pressed("m") || Input.is_action_pressed("touch"):
		#start_moving()

	if is_moving:
		move_timer -= delta
		move(delta)
		if move_timer <= 0:
			stop_moving()  # Stop movement after the duration

func move(delta):
	# Move the slime randomly
	position += direction * speed * delta
	position.x = clamp(position.x, 0, area_size.x)
	position.y = clamp(position.y, 0, area_size.y)

func change_direction():
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func start_moving():
	is_moving = true
	move_timer = move_duration  # Set the timer to 4 seconds
	change_direction()  # Give it an initial direction

func stop_moving():
	is_moving = false
	direction = Vector2.ZERO  # Stop movement


# Check if touch is inside the slime's collision shape
func is_touching_slime(touch_position: Vector2) -> bool:
	# Convert touch position to local space of slime by subtracting slime's position
	var local_touch_position = to_local(touch_position)
	var collision_shape = $CollisionShape2D
	
	# Check if the touch is inside the slime's collision shape
	if collision_shape:
		return collision_shape.shape.get_rect().has_point(local_touch_position)
	return false
