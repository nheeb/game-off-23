extends Node3D

func _ready():
	rigidify_model()

func _process(delta):
	pass

func rigidify_model():
	for c in $model.get_children():
		var r = RigidBody3D.new()
		$model.remove_child(c)
		r.add_child(c)
		c.set_owner(r)
		var m = MeshInstance3D.new()
		m.mesh = c.mesh
		m.create_multiple_convex_collisions()
		var shape = m.get_child(0).shape_owner_get_shape(0,0)
		r.shape_owner_add_shape(0, shape)
		r.collision_layer = 1
		r.collision_mask = 1
		print(shape)
		$model.add_child(r)
		print(c)
