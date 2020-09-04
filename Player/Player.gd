extends KinematicBody2D


const FRICTION = 500
const MAX_SPEED = 80
const ACCELERATION = 500
const ROLL_SPEED = 1.25

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE

var speed: float = 4
var velocity = Vector2.ZERO
var rollVector = Vector2.DOWN

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true

func _physics_process(delta):
	
	match state:
		MOVE:
			MoveState(delta)
		ROLL:
			RollState(delta)
		ATTACK:
			AttackState(delta)

func AttackState(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func RollState(delta):
	velocity = rollVector * MAX_SPEED * ROLL_SPEED
	animationState.travel("Roll")
	Move()


func MoveState(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	
	if input_vector != Vector2.ZERO:
		rollVector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector) #cant change direction mid attack
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	Move()

	if Input.is_action_just_pressed("roll"):
		state = ROLL
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func Move():
	velocity = move_and_slide(velocity)

func RollAnimFinished():
	state = MOVE

func AttackAnimFinished():
	state = MOVE
