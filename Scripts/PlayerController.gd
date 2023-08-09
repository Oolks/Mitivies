extends KinematicBody


export var speed := 7.0
export var jump_power := 15.0
export var gravity := 65.0
export var isMoving = false

var pre_jump_rotation = Vector3.ZERO
var _velocity := Vector3.ZERO
var _snap_vector := Vector3.DOWN

onready var spring_arm = $SpringArm
onready var animation_handler = $AnimationPlayer2
onready var mesh = $Sketchfab_model
onready var jumptime = 0

func _ready() -> void:
	$PointerPlayer.play("Pointer")
	jumptime = OS.get_unix_time()

func _physics_process(delta) -> void:
	var movement_direction = Vector3.ZERO
	movement_direction.x = Input.get_action_strength("Right") - Input.get_action_strength("Left") 
	movement_direction.z = Input.get_action_strength("Backwards") - Input.get_action_strength("Forward")
	movement_direction = movement_direction.rotated(Vector3.UP, spring_arm.rotation.y).normalized()
	
	_velocity.x = movement_direction.x * speed
	_velocity.z = movement_direction.z * speed
	_velocity.y -= gravity * delta
	
	var just_landed := is_on_floor() and _snap_vector == Vector3.ZERO
	var is_jumping := is_on_floor() and Input.is_action_pressed("Jump")
	isMoving = Input.is_action_pressed("Left") || Input.is_action_pressed("Right") || Input.is_action_pressed("Forward") || Input.is_action_pressed("Backwards")
	
	if is_jumping and OS.get_unix_time() - jumptime >= 1:
		pre_jump_rotation = mesh.rotation
		_velocity.y = jump_power
		_snap_vector = Vector3.ZERO
		jumptime = OS.get_unix_time()
	elif just_landed:
		_snap_vector = Vector3.DOWN
		mesh.rotation = pre_jump_rotation
	
	if isMoving:
		animation_handler.play("Run",-1,1,false)
	else:
		animation_handler.play("Idle",-1,1,false)
	
	_velocity = move_and_slide_with_snap(_velocity, _snap_vector, Vector3.UP, true)
	
	if _velocity.length() > 0.2:
			var look_direction = Vector2(_velocity.z, _velocity.x)
			var target_angle = look_direction.angle()
			mesh.rotation.y = lerp_angle(mesh.rotation.y, target_angle, 0.1)
	
func _process(_delta) -> void:
	var camera_offset := Vector3(0,2.252,0)
	spring_arm.translation = translation + camera_offset
