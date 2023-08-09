extends LightOccluder2D

#var numSides := 13
#var radius := 50.0


export var numSides := 1
export var radius := 50.0


var increment: float = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	setLightOccluderPolySides(numSides)

func setLightOccluderPolySides(numSides: int) -> void:
	increment = 2.0 * PI / float(numSides)

	var polygon := PoolVector2Array()
	for i in range(numSides):
		var angle := increment * float(i)
		var x := radius * cos(angle)
		var y := radius * sin(angle)
		polygon.append(Vector2(x, y))

	occluder.polygon = polygon

func setLightOccluderRadius(newRadius: float) -> void:
	radius = newRadius
	setLightOccluderPolySides(numSides)
