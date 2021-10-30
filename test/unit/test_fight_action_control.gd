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

#测试抢占类型
func action_control_cpx():
	#var action_control = BaseFightActionController.new()
	var action_control = load("res://FrameWork/Fight/BaseFightGestureController.tscn").instance()

	add_child(action_control)
	
	for i in 100:
		action_control.regist_action(1,0,ActionInfo.EXEMOD_SEQ,-1,["test"+id as String ,1])
		id=id+1
		pass
	
	action_control.regist_action(1,100,ActionInfo.EXEMOD_SEQ,-1,["test"+id as String ,1])
	
	for i in 300:
		action_control._physics_process(1)
	
	assert_true(action_control.current_index ==100, "current index "+action_control.current_index as String)
	assert_true(action_control._current_action.state ==ActionInfo.STATE_ING, "current index "+action_control.current_index as String)
	
	yield(get_tree().create_timer(1.0),"timeout")
	
	action_control._physics_process(1)
	assert_true(action_control.current_index ==101, "current index "+action_control.current_index as String)
	assert_true(action_control._current_action==null, "current index "+action_control.current_index as String)
	
	pass
	
func test_action_generous():
		#var action_control = BaseFightActionController.new()
	var action_control = load("res://FrameWork/Fight/BaseFightGestureController.tscn").instance() as BaseFightActionController
	
	for i in 3:
		action_control.regist_action(1,0,ActionInfo.EXEMOD_SEQ,1,["test"+id as String ,1])
		id=id+1
		pass
	pass
	
	action_control.regist_action(1,0,ActionInfo.EXEMOD_GENEROUS,1,["test"+id as String ,1])
	
	assert_true(action_control.action_array.size() ==4, "size"+action_control.action_array.size() as String)
	
	for i in 3:
		action_control.regist_action(1,0,ActionInfo.EXEMOD_SEQ,1,["test"+id as String ,1])
		id=id+1
		pass
	
	for i in 7:
		action_control._physics_process(1)		
		
	assert_true(action_control.current_index ==4, "current index "+action_control.current_index as String)
	assert_true(action_control._current_action.execution_mod == ActionInfo.EXEMOD_SEQ, "current index "+action_control.current_index as String)
	assert_true(action_control.action_array.size() ==7, "size"+action_control.action_array.size() as String)
	
	
	pass

#测试group newest
func test_action_group_newest():
	
	#var action_control = BaseFightActionController.new()
	var action_control = load("res://FrameWork/Fight/BaseFightGestureController.tscn").instance() as BaseFightActionController
	
	# add 3 group_newest
	for i in 3:
		action_control.regist_action(1,1,ActionInfo.EXEMOD_GROUP_NEWEST,1,["test"+id as String ,1])
		id=id+1
		pass
	pass
	# do 4 fimes,now in group 1
	for i in 4:
		yield(get_tree().create_timer(0.02),"timeout")
		action_control._physics_process(401)

	assert_true(action_control.current_index ==2, "current index "+action_control.current_index as String)
	assert_true(action_control._current_action!=null, "current index "+action_control.current_index as String)
	assert_true(action_control.action_array.size() ==3, "size"+action_control.action_array.size() as String)
	
	# add 3 group_newest,now 6 group_newest
	for i in 3:
		action_control.regist_action(1,1,ActionInfo.EXEMOD_GROUP_NEWEST,2,["test"+id as String ,1])
		id=id+1
		pass
	pass
	
	assert_true(action_control.current_index ==2, "current index "+action_control.current_index as String)
	assert_true(action_control._current_action!=null, "current index "+action_control.current_index as String)
	assert_true(action_control.action_array.size() ==6, "size"+action_control.action_array.size() as String)
	
	# add 3 group_newest, replace 3 group, now still 6 group_newest
	for i in 3:
		action_control.regist_action(1,1,ActionInfo.EXEMOD_GROUP_NEWEST,3,["test"+id as String ,1])
		id=id+1
		pass
	pass

	assert_true(action_control.current_index ==2, "current index "+action_control.current_index as String)
	assert_true(action_control._current_action!=null, "current index "+action_control.current_index as String)
	assert_true(action_control.action_array.size() ==6, "size"+action_control.action_array.size() as String)
	
	#do 4 times ,now in group 2
	for i in 4:
		yield(get_tree().create_timer(0.001),"timeout")
		action_control._physics_process(401)
		
	assert_true(action_control.current_index ==4, "current index "+action_control.current_index as String)
	assert_true(action_control._current_action!=null, "current index "+action_control.current_index as String)
	assert_true(action_control.action_array.size() ==6, "size"+action_control.action_array.size() as String)
	assert_true(action_control._current_action.group_id==3, "current index "+action_control.current_index as String)
	
	#add 1 SEQ action,
	action_control.regist_action(1,0,ActionInfo.EXEMOD_SEQ,-1,["test"+id as String ,1])
	assert_true(action_control.action_array.size() ==7, "size"+action_control.action_array.size() as String)
	#add 1 newest action
	action_control.regist_action(1,0,ActionInfo.EXEMOD_NEWEST,-1,["test"+id as String ,1])
	assert_true(action_control.action_array.size() ==8, "size"+action_control.action_array.size() as String)
	#add 1 interupt action
	action_control.regist_action(1,0,ActionInfo.EXEMOD_INTERUPT,-1,["test"+id as String ,1])
	assert_true(action_control.action_array.size() ==5, "size"+action_control.action_array.size() as String)
	#add 3 group new
	for i in 3:
		action_control.regist_action(1,1,ActionInfo.EXEMOD_GROUP_NEWEST,3,["test"+id as String ,1])
		id=id+1
		pass
	pass
	
	assert_true(action_control.current_index ==4, "current index "+action_control.current_index as String)
	assert_true(action_control._current_action!=null, "current index "+action_control.current_index as String)
	assert_true(action_control.action_array.size() ==8, "size"+action_control.action_array.size() as String)
	
	action_control.regist_action(1,0,ActionInfo.EXEMOD_NEWEST,-1,["test"+id as String ,1])
	assert_true(action_control.action_array.size() ==6, "size"+action_control.action_array.size() as String)

	for i in 3:
		action_control.regist_action(1,1,ActionInfo.EXEMOD_GROUP_NEWEST,4,["test"+id as String ,1])
		id=id+1
		pass
	pass
	assert_true(action_control.current_index ==4, "current index "+action_control.current_index as String)
	assert_true(action_control._current_action!=null, "current index "+action_control.current_index as String)
	assert_true(action_control.action_array.size() ==8, "size"+action_control.action_array.size() as String)
	
	action_control.regist_action(1,0,ActionInfo.EXEMOD_SEQ,-1,["test"+id as String ,1])
	assert_true(action_control.current_index ==4, "current index "+action_control.current_index as String)
	assert_true(action_control._current_action!=null, "current index "+action_control.current_index as String)
	assert_true(action_control.action_array.size() ==6, "size"+action_control.action_array.size() as String)
	

#测试不同exemod类型的
func test_action_newest():
	
	#var action_control = BaseFightActionController.new()
	var action_control = load("res://FrameWork/Fight/BaseFightGestureController.tscn").instance()
	
	add_child(action_control)
	var instanceArray =[]
	for i in 100:
		action_control.regist_action(1,0,ActionInfo.EXEMOD_NEWEST,-1,["test"+id as String ,1])
		id=id+1
		pass
	assert_true(action_control.current_index ==0, "current index "+action_control.current_index as String)
	assert_true(action_control.action_array.size() ==2, "size"+action_control.action_array.size() as String)
	
	for i in 200:
		action_control._physics_process(1)
	assert_true(action_control.current_index ==2, "current index "+action_control.current_index as String)
	assert_true(action_control.action_array.size() ==2, "size"+action_control.action_array.size() as String)
	
	for i in 5:
		action_control.regist_action(1,0,ActionInfo.EXEMOD_SEQ,-1,["test"+id as String ,1])
		id=id+1
		pass
	assert_true(action_control.current_index ==2, "current index "+action_control.current_index as String)
	assert_true(action_control.action_array.size() ==7, "size"+action_control.action_array.size() as String)
	
	for i in 200:
		action_control._physics_process(1)
	assert_true(action_control.current_index ==7, "current index "+action_control.current_index as String)
	assert_true(action_control.action_array.size() ==7, "size"+action_control.action_array.size() as String)
	
	for i in 5:
		action_control.regist_action(1,0,ActionInfo.EXEMOD_SEQ,-1,["test"+id as String ,1])
		id=id+1
		pass
	assert_true(action_control.current_index ==7, "current index "+action_control.current_index as String)
	assert_true(action_control.action_array.size() ==12, "size"+action_control.action_array.size() as String)
	
	action_control.regist_action(1,0,ActionInfo.EXEMOD_INTERUPT,-1,["test"+id as String ,1])
	
	assert_true(action_control.current_index ==7, "current index "+action_control.current_index as String)
	assert_true(action_control.action_array.size() ==8, "size"+action_control.action_array.size() as String)
	
	for i in 200:
		action_control._physics_process(1)
	assert_true(action_control.current_index ==8, "current index "+action_control.current_index as String)
	assert_true(action_control.action_array.size() ==8, "size"+action_control.action_array.size() as String)
	
#简单的流程测试
func test_action_control():
	
	var action_control = load("res://FrameWork/Fight/BaseFightGestureController.tscn").instance()
	add_child(action_control)
	var instanceArray =[]
	for i in 100:
		action_control.regist_action(1,0,ActionInfo.EXEMOD_SEQ,-1,["test"+id as String ,1])
		id=id+1
		pass
	
	assert_true(action_control.action_array.size() ==100, "")
	
	for i in 200:
		action_control._physics_process(1)
	assert_true(action_control.current_index ==100, "current index "+action_control.current_index as String)
	
	for i in 5:
		action_control.regist_action(1,0,ActionInfo.EXEMOD_SEQ,-1,["test 10"+id as String ,1])
		id=id+1
	assert_true(action_control.action_array.size() ==105, "get size "+action_control.action_array.size() as String)
	assert_true(action_control.current_index ==100, "current index "+action_control.current_index as String)
	
	for i in 10:
		action_control._physics_process(1)
	
	assert_true(action_control.action_array.size() ==105, "get size "+action_control.action_array.size() as String)
	assert_true(action_control.current_index ==105, "current index "+action_control.current_index as String)
	
	for i in 5:
		action_control.regist_action(1,0,ActionInfo.EXEMOD_SEQ,-1,["test 10"+id as String ,1])
		id=id+1
	assert_true(action_control.action_array.size() ==6, "get size "+action_control.action_array.size() as String)
	assert_true(action_control.current_index ==1, "current index "+action_control.current_index as String)
	
	for i in 30:
		action_control._physics_process(1)
	
	assert_true(action_control.current_index ==6, "current index "+action_control.current_index as String)
	
	assert_null(action_control._current_action)
