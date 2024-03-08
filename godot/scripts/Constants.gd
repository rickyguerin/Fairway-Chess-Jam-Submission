class_name G

enum Player {WHITE, BLACK}


static func can_attack(attacker, defender):
	for angle in attacker.allowed_directions:
		var tri := get_triangle_points(attacker, angle)
		if point_is_in_triangle(defender.position, tri[0], tri[1], tri[2]):
			return angle

	return false


static func get_triangle_points(attacker, angle) -> Array[Vector3]:
	var points: Array[Vector3] = [attacker.position]

	var minus_dir = Vector3.FORWARD.rotated(Vector3.UP, deg_to_rad(angle - attacker.max_angle)).normalized()
	var plus_dir = Vector3.FORWARD.rotated(Vector3.UP, deg_to_rad(angle + attacker.max_angle)).normalized()

	points.append(attacker.position + minus_dir * attacker.max_impulse / 2)
	points.append(attacker.position + plus_dir * attacker.max_impulse / 2)

	return points


static func point_is_in_triangle(p: Vector3, a: Vector3, b: Vector3, c: Vector3) -> bool:
	var bdx := b.x - a.x
	var bdz := b.z - a.z
	var cdx := c.x - a.x
	var cdz := c.z - a.z
	var pdz := p.z - a.z
	
	var w1 := (a.x * cdz + pdz * cdx - p.x * cdz) / (bdz * cdx - bdx * cdz)
	var w2 := (pdz - w1 * bdz) / cdz

	if (w1 < 0) or (w2 < 0) or (w1 + w2 > 1):
		return false

	return true
