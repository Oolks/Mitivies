extends SpringArm

export var mouse_sensitivity := 0.08

func _ready() -> void:
	set_as_toplevel(true)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(BUTTON_RIGHT):
		rotation_degrees.x -= event.relative.y * mouse_sensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, -90.0, 30.0)
		
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360)
			
	if event is InputEventMouseButton:
		match event.button_index:
			BUTTON_RIGHT: # Only allows rotation if right click down
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED if event.pressed else Input.MOUSE_MODE_VISIBLE)
