class_name CATS_MOVEABLE extends CATS

@export var moveable : bool = true
@export var speed : int = 50

enum State { IDLE, MOVE, ACTIVE }
var current_state: State = State.IDLE
var state_change_timer = Timer.new()
var active_timer = Timer.new()
var target_position = Vector2.ZERO
var viewport_size

func _ready():
	viewport_size = get_viewport_rect().size
	add_child(state_change_timer)
	add_child(active_timer)
	
	active_timer.wait_time = 2

	state_change_timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	active_timer.connect("timeout", Callable(self, "_on_timer_timeout"))

	randomize_position()
	randomize_state()

func randomize_position():
	position = Vector2(randi_range(0, int(viewport_size.x)), randi_range(0, int(viewport_size.y)))

func _on_timer_timeout():
	state_change_timer.wait_time = randi_range(3, 6)
	randomize_state()

func randomize_state():
	if randi() % 2 == 0:
		start_idle_state()
	else:
		start_move_state()

func start_idle_state():
	current_state = State.IDLE
	sprite.play('idle')
	state_change_timer.start()

func start_move_state():
	current_state = State.MOVE
	sprite.play('move')
	
	# set target position
	target_position = Vector2(
		randf_range(100, get_viewport_rect().size.x), 
		randf_range(100, get_viewport_rect().size.y)
	)
	sprite.flip_h = target_position.x < sprite.position.x
	state_change_timer.start()

func handle_move_state(delta):
	var direction = (target_position - sprite.position).normalized()
	sprite.position += direction * speed * delta
	
	if sprite.position.distance_to(target_position) < 10:
		randomize_state()

func handle_active_state():
	sprite.play('active')

func _process(delta):
	print(current_state, ' ' ,viewport_size, ' ', target_position, ' ', sprite.position)
	#sprite.position = Vector2(200, 1100)
	match current_state:
		State.MOVE:
			handle_move_state(delta)

func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		current_state = State.ACTIVE
		state_change_timer.stop()
		active_timer.start()
