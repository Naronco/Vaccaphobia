extends KinematicBody



# How fast the player moves in meters per second.
export var speed = 2
export var gravity = 9.81

var velocity = Vector3.ZERO



# current rotation angle
var curPhi = 0
var targetPhi = 0
export var lerpSpeed = 10

var flashlightAngle = 0
var flashlightAngleCur = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func lerp_angle(from, to, weight):
    return from + short_angle_dist(from, to) * weight

func short_angle_dist(from, to):
    var max_angle = PI * 2
    var difference = fmod(to - from, max_angle)
    return fmod(2 * difference, max_angle) - difference

# framerate-independent lerping
func damp_angle(from, to, lambda, dt):
	return lerp_angle(from, to, 1 - exp(-lambda * dt))
	
func _physics_process(delta):
	# We create a local variable to store the input direction.
	var direction = Vector3.ZERO
	
	var cam = get_node("Camera")
	var rot = get_node("Rotation")
	var light = get_node("Rotation/FlashLight")
	
	var right = cam.transform.basis.x
	var up = cam.transform.basis.y
	var forward = cam.transform.basis.z

	# project forward on (x,z)-plane
	var planeForward = forward
	planeForward.y = 0
	planeForward = planeForward.normalized()

	# project right on (x,z)-plane
	var planeRight = right
	planeRight.y = 0
	planeRight = planeRight.normalized()
	

	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("move_right"):
		direction += planeRight
	if Input.is_action_pressed("move_left"):
		direction -= planeRight
	if Input.is_action_pressed("move_down"):
		direction += planeForward
	if Input.is_action_pressed("move_up"):
		direction -= planeForward

	light.transform.basis = Basis(Vector3(1, 0, 0), -PI/4)
	
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		
		# Direction to angle
		targetPhi = 0.5*PI + atan2(direction.z, direction.x)
		
		flashlightAngle = -PI/4

	else:
		flashlightAngle = 0
		
		
		
	# Rotate player accordingly
	curPhi = damp_angle(curPhi, targetPhi, lerpSpeed, delta)
	flashlightAngleCur = damp_angle(flashlightAngleCur, flashlightAngle, lerpSpeed, delta)
	
	rot.transform = self.get_parent().transform.rotated(Vector3(0, 1, 0), -curPhi)
	light.transform.basis = Basis(Vector3(1, 0, 0), flashlightAngleCur)
	
	# Ground velocity
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	#var on_steep = false
	#for i in get_slide_count():
	#	var collision = get_slide_collision(i)
	#	if collision.normal.dot(Vector3.UP) < 0.5: # TODO: make less arbitrary
	#		on_steep = true
	#		break # no need to check the rest of the slopes

	#if not is_on_floor() or on_steep:
	#	# Vertical velocity
	#	velocity.y -= gravity * delta

	# Moving the character
	velocity = move_and_slide(velocity, Vector3.UP, false, 4, 60.0/180.0*PI)
	velocity.y = 0
	
	# place player on floor
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(self.transform.origin + Vector3(0, 1.3, 0), self.transform.origin + Vector3(0, -100, 0))
	
	var rad = get_node("CollisionShape").shape.get_radius()
	
	if not is_on_floor() and result:
		print("Hit at point/normal: ", result.position, result.normal)
		#transform.origin = result.position + rad*result.normal
		transform.origin = result.position + Vector3.UP*rad*(1/result.normal.y-1)
	
