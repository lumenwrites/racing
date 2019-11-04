extends VehicleBody

const MAX_STEER_ANGLE = 0.35
const STEER_SPEED = 1
const MAX_ENGINE_FORCE = 175
const MAX_BRAKE_FORCE = 10
const MAX_SPEED = 30

var steer_target = 0.0 # where does the player want the weels t ogo
var steer_angle = 0.0 # where is the wheel now

func _physics_process(delta):
	drive(delta)
	
func drive(delta):
	steering = apply_steering(delta)
	engine_force = apply_throttle()
	brake = apply_brakes()
	
func apply_brakes():
	var brake_val = 0
	var brake_strength = Input.get_action_strength("brake")
	if brake_strength: brake_val = brake_strength
	return brake_val * MAX_BRAKE_FORCE
	
func apply_throttle():
	var throttle_val = 0
	var forward = Input.get_action_strength("forward")
	var back = Input.get_action_strength("back")
	if linear_velocity.length() < MAX_SPEED:
		if back: throttle_val = -back
		if forward: throttle_val = forward
	return throttle_val * MAX_ENGINE_FORCE
	
		
func apply_steering(delta):
	var steer_val = 0
	var left = Input.get_action_strength("steer_left")
	var right = Input.get_action_strength("steer_right")
	if left: 
		steer_val = left
	if right: 
		steer_val = -right
	# The angle I want to turn by is strength of the joystick input * max angle
	steer_target = steer_val * MAX_STEER_ANGLE
	# Gradually move actual steer angle closer to steer target
	if steer_target < steer_angle:
		steer_angle -= STEER_SPEED * delta
	elif steer_target > steer_angle:
		steer_angle += STEER_SPEED * delta
		
	return steer_angle
