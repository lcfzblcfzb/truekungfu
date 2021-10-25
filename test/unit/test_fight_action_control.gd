extends "res://addons/gut/test.gd"
func before_each():
	gut.p("ran setup", 2)

func after_each():
	gut.p("ran teardown", 2)

func before_all():
	gut.p("ran run setup", 2)

func after_all():
	gut.p("ran run teardown", 2)

var id =0
func test_pool():
	
	var action_control = BaseFightActionController.new()
	add_child(action_control)
	var instanceArray =[]
	for i in 100:
		action_control.regist_action(1,0,["test"+id as String ,1])
		id=id+1
		pass
	
	assert_true(action_control.action_array.size() ==100, "")
	
	for i in 200:
		action_control._physics_process(1)
	
	for i in 5:
		action_control.regist_action(1,0,["test 10"+id as String ,1])
		id=id+1
	assert_true(action_control.action_array.size() ==4, "get size "+action_control.action_array.size() as String)
	
	for i in 10:
		action_control._physics_process(1)
	
	assert_true(action_control.action_array.size() ==4, "get size "+action_control.action_array.size() as String)
	for i in 5:
		action_control.regist_action(1,0,["test 10"+id as String ,1])
		id=id+1
	assert_true(action_control.action_array.size() ==4, "get size "+action_control.action_array.size() as String)
	
