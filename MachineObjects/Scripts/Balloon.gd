extends MachineObject

class_name Balloon

export var airDensity = 0.0012041 # kg/px^2 = 1.2041 kg/m^2 (1m = 10px -> 1m^2 = 10*10px^2 = 100px^2
var uplift = Vector2.ZERO
var gravity = Vector2.ZERO
onready var colShape = get_node("CollisionShape2D")
	
func _physics_process(delta: float) -> void:
	if (!isStatic && isActive):
		applied_force = Vector2.ZERO
		var balloonArea = 0
		for i in range(colShape.polygon.size()):
			var prev = i - 1;
			if prev < 0:
				prev = colShape.polygon.size() - 1
			var next = i + 1
			if next >= colShape.polygon.size():
				next = 0
			balloonArea = balloonArea + (colShape.polygon[i].y * (colShape.polygon[prev].x - colShape.polygon[next].x))
			
		balloonArea  = balloonArea / 2.0
		
		gravity = Physics2DServer.area_get_param(get_viewport().find_world_2d().space, Physics2DServer.AREA_PARAM_GRAVITY) * Physics2DServer.area_get_param(get_viewport().find_world_2d().space, Physics2DServer.AREA_PARAM_GRAVITY_VECTOR)
		uplift = airDensity * balloonArea * (-gravity) # kg/px^2 * px^2 * px/s^2 = kg*px/s^2
		add_central_force(uplift * delta)
		._physics_process(delta)
