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

func action_control_cpx():
	var action_control = BaseFightActionController.new()
	add_child(action_control)
	
	for i in 100:
		action_control.regist_action(1,0,BaseFightActionController.ActionInfo.EXEMOD_SEQ,["test"+id as String ,1])
		id=id+1
		pass
	
	action_control.regist_action(1,100,BaseFightActionController.ActionInfo.EXEMOD_SEQ,["test"+id as String ,1])
	
	for i in 300:
		action_control._physics_process(1)
	
	assert_true(action_control.current_index ==100, "current index "+action_control.current_index as String)
	assert_true(action_control._current_action.state ==BaseFightActionController.ActionInfo.STATE_ING, "current index "+action_control.current_index as String)
	
	yield(get_tree().create_timer(1.0),"timeout")
	
	action_control._physics_process(1)
	assert_true(action_control.current_index ==101, "current index "+action_control.current_index as String)
	assert_true(action_control._current_action==null, "current index "+action_control.current_index as String)
	
	pass

func test_action_newest():
	
	var action_control = BaseFightActionController.new()
	add_child(action_control)
	var instanceArray =[]
	for i in 100:
		action_control.regist_action(1,0,BaseFightActionController.ActionInfo.EXEMOD_NEWEST,["test"+id as String ,1])
		id=id+1
		pass
	assert_true(action_control.current_index ==0, "current index "+action_control.current_index as String)
	assert_true(action_control.action_array.size() ==2, "size"+action_control.action_array.size() as String)
	
	for i in 200:
		action_control._physics_process(1)
	assert_true(action_control.current_index ==2, "current index "+action_control.current_index as String)
	assert_true(action_control.action_array.size() ==2, "size"+action_control.action_array.size() as String)
	
	for i in 5:
		action_control.regist_action(1,0,BaseFightActionController.ActionInfo.EXEMOD_SEQ,["test"+id as String ,1])
		id=id+1
		pass
	assert_true(action_control.current_index ==2, "current index "+action_control.current_index as String)
	assert_true(action_control.action_array.size() ==7, "size"+action_control.action_array.size() as String)
	
	for i in 200:
		action_control._physics_process(1)
	assert_true(action_control.current_index ==7, "current index "+action_control.current_index as String)
	assert_true(action_control.action_array.size() ==7, "size"+action_control.action_array.size() as String)
	
	for i in 5:
		action_control.regist_action(1,0,BaseFightActionController.ActionInfo.EXEMOD_SEQ,["test"+id as String ,1])
		id=id+1
		pass
	assert_true(action_control.current_index ==7, "current index "+action_control.current_index as String)
	assert_true(action_control.action_array.size() ==12, "size"+action_control.action_array.size() as String)
	
	action_control.regist_action(1,0,BaseFightActionController.ActionInfo.EXEMOD_INTERUPT,["test"+id as String ,1])
	
	assert_true(action_control.current_index ==7, "current index "+action_control.current_index as String)
	assert_true(action_control.action_array.size() ==8, "size"+action_control.action_array.size() as String)
	
	for i in 200:
		action_control._physics_process(1)
	assert_true(action_control.current_index ==8, "current index "+action_control.current_index as String)
	assert_true(action_control.action_array.size() ==8, "size"+action_control.action_array.size() as String)
	
	
func test_action_control():
	
	var action_control = BaseFightActionController.new()
	add_child(action_control)
	var instanceArray =[]
	for i in 100:
		action_control.regist_action(1,0,BaseFightActionController.ActionInfo.EXEMOD_SEQ,["test"+id as String ,1])
		id=id+1
		pass
	
	assert_true(action_control.action_array.size() ==100, "")
	
	for i in 200:
		action_control._physics_process(1)
	assert_true(action_control.current_index ==100, "current index "+action_control.current_index as String)
	
	for i in 5:
		action_control.regist_action(1,0,BaseFightActionController.ActionInfo.EXEMOD_SEQ,["test 10"+id as String ,1])
		id=id+1
	assert_true(action_control.action_array.size() ==105, "get size "+action_control.action_array.size() as String)
	assert_true(action_control.current_index ==100, "current index "+action_control.current_index as String)
	
	for i in 10:
		action_control._physics_process(1)
	
	assert_true(action_control.action_array.size() ==105, "get size "+action_control.action_array.size() as String)
	assert_true(action_control.current_index ==105, "current index "+action_control.current_index as String)
	
	for i in 5:
		action_control.regist_action(1,0,BaseFightActionController.ActionInfo.EXEMOD_SEQ,["test 10"+id as String ,1])
		id=id+1
	assert_true(action_control.action_array.size() ==6, "get size "+action_control.action_array.size() as String)
	assert_true(action_control.current_index ==1, "current index "+action_control.current_index as String)
	
	for i in 30:
		action_control._physics_process(1)
	
	assert_true(action_control.current_index ==6, "current index "+action_control.current_index as String)
	
	assert_null(action_control._current_action)
