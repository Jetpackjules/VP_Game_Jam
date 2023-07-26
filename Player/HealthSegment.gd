extends Polygon2D




func set_active(active):
	if active:
		self.color = Color.white
	else:
		self.color = Color.black
	var points = get_polygon()
	points.append(Vector2(0,0))
	$Outline.points = points

