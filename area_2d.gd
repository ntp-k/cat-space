extends Area2D

@export var area_size: Vector2 = Vector2(400, 400)  # Movement boundary
@export var speed: float = 50  # Movement speed
@export var change_direction_time: float = 4.0  # Time before changing direction

var direction: Vector2 = Vector2.ZERO
var timer: float = 0.0

func _ready():
	$AnimatedSprite2D.play("idle")
	change_direction()
	

func _process(delta):
	timer -= delta
	if timer <= 0:
		change_direction()

	# Move and keep the slime inside the area
	position += direction * speed * delta
	position.x = clamp(position.x, 0, area_size.x)
	position.y = clamp(position.y, 0, area_size.y)

func change_direction():
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	timer = change_direction_time
