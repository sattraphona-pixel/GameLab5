class_name Tint
# Helper: swap the "Kenney colormap" material for the sunset version (used in Level 2).
static func apply(node: Node):
	var mat = load("res://Assets/Materials/kenney_sunset.tres")
	for c in node.find_children("*", "MeshInstance3D", true, false):
		if c.has_meta("kenney"):
			c.material_override = mat
