extends Node3D

func _ready():
	rigidify_model()

func _process(delta):
	pass

func rigidify_model():
	for c in $model.get_children():
		var r = RigidBody3D.new()
		self.add_child(r)
		$model.remove_child(c)
		r.add_child(c)
		c.set_owner(r)
		var m = MeshInstance3D.new()
		m.mesh = c.mesh
		m.create_multiple_convex_collisions()
		
#		var shape = m.get_child(0).shape_owner_get_shape(0,0)
#		r.shape_owner_add_shape(0, shape)
		var shape = m.get_child(0).get_child(0)
		m.get_child(0).remove_child(shape)
		r.add_child(shape)
		shape.set_owner(r)
		
		r.collision_layer = 0
		r.collision_mask = 1
		
		
		
		print(shape)
		
		r.apply_force(100.0*Vector3(randf_range(-1.0, 1.0), 1.0, randf_range(-1.0, 1.0)))
		
		print(c)
