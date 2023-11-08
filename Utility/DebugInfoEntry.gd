extends Control

var info_name := "": 
	set(value):
		info_name = value
		if not is_node_ready():
			await self.ready
		$HBoxContainer/LabelName.text = value
var info_value := "":
	set(value):
		info_value = value
		if not is_node_ready():
			await self.ready
		$HBoxContainer/LabelValue.text = value

func set_info(_name, _value):
	self.info_name = _name
	self.info_value = _value
