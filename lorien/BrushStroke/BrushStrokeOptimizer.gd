class_name BrushStrokeOptimizer

# -------------------------------------------------------------------------------------------------
const ANGLE_THRESHOLD := 1.0
const DISTANCE_THRESHOLD := 2.0

# -------------------------------------------------------------------------------------------------
var points_removed := 0

# -------------------------------------------------------------------------------------------------
func reset() -> void:
	points_removed = 0

# -------------------------------------------------------------------------------------------------
func optimize(s: BrushStroke) -> void:
	if s.points.size() < 8:
		return
	
	var max_angle_diff := ANGLE_THRESHOLD
	var max_distance := DISTANCE_THRESHOLD
	
	var filtered_points := []
	var filtered_pressures := []
	
	filtered_points.append(s.points.front())
	filtered_pressures.append(s.pressures.front())
	
	var previous_angle := 0.0
	for i in range(1, s.points.size()):
		var prev_point: Vector2 = s.points[i-1]
		var point: Vector2 = s.points[i]
		var pressure = s.pressures[i]
		
		# Distance between 2 points must be greater than x
		var distance = prev_point.distance_to(point)
		var distance_cond = distance > max_distance # TODO: make dependent on zoom level
	
		# Angle between points must be beigger than x deg
		var angle := rad_to_deg(prev_point.angle_to_point(point))
		var angle_diff :float= abs(abs(angle) - abs(previous_angle))
		var angle_cond :bool= angle_diff >= max_angle_diff
		previous_angle = angle
		
		var point_too_far_away = distance > 100
		
		if point_too_far_away || (distance_cond && angle_cond):
			filtered_points.append(point)
			filtered_pressures.append(pressure)
		else:
			points_removed += 1

	# add back last point
	if !filtered_points.back().is_equal_approx(s.points.back()):
		filtered_points.append(s.points.back())
		filtered_pressures.append(s.pressures.back())

	s.points = filtered_points
	s.pressures = filtered_pressures
