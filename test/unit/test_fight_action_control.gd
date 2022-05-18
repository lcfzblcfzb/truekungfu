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
func test_action_control_cpx():
	#var action_control = BaseFightActionController.new()
	var action_control = load("res://FrameWork/Fight/Action/FightActionMng.tscn").instance()

	add_child(action_control)
	
	for i in 100:
		action_control.regist_action(Glob.FightMotion.Idle,0,ActionInfo.EXEMOD_SEQ,-1,["test"+id as String ,1])
		id=id+1
		pass
	
	action_control.regist_action(Glob.FightMotion.Idle,100,ActionInfo.EXEMOD_SEQ,-1,["test"+id as String ,1])
	
	for i in 300:
		action_control._physics_process(1)
	
	assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==101, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
#	assert_true(action_control.get_current_action(Glob.ActionHandlingType.Movement).state ==ActionInfo.STATE_ING, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	
	yield(get_tree().create_timer(1.0),"timeout")
	
	action_control._physics_process(1)
	assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==101, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	assert_true(action_control.get_current_action(Glob.ActionHandlingType.Movement)==null, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	
	pass
	
func test_action_generous():
	
	
	#var action_control = BaseFightActionController.new()
	var action_control = load("res://FrameWork/Fight/Action/FightActionMng.tscn").instance() as FightActionMng
	
	add_child(action_control)
	
	action_control.get_handler_by_handling_type(Glob.ActionHandlingType.Movement).MAX_ACTION_ARRAY_SIZE=10000

	action_control.regist_action(Glob.FightMotion.Idle,0,ActionInfo.EXEMOD_NEWEST,-1,["test"+id as String ,1])
	id=id+1
	
	var input_array = [Glob.FightMotion.Idle ,OS.get_ticks_msec(),["test"+id as String ,1],0*1000,ActionInfo.EXEMOD_GENEROUS,-1]
	var action =Glob.getPollObject(ActionInfo,input_array)
#	action.not_generous_type.append(Glob.FightMotion.Idle)
	action_control.regist_actioninfo(action)
	
	assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==0, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==2, "size"+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	
	action_control._physics_process(1)
	
	assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==0, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==2, "size"+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	
	action_control._physics_process(1)
	
	assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==1, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==2, "size"+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	
	
	action_control._physics_process(1)
	
	assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==1, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==2, "size"+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	
	
	action_control._physics_process(1)
	
	assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==2, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==2, "size"+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	
	action_control.regist_action(Glob.FightMotion.Idle,0,ActionInfo.EXEMOD_NEWEST,-1,["test"+id as String ,1])
	id=id+1
	
	var input_array2 = [Glob.FightMotion.Idle ,OS.get_ticks_msec(),["test"+id as String ,1],0*1000,ActionInfo.EXEMOD_GENEROUS,-1]
	var action2 =Glob.getPollObject(ActionInfo,input_array2)
	action2.not_generous_type.append(Glob.FightMotion.Idle)
	action_control.regist_actioninfo(action2)
	
	assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==2, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==4, "size"+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	
	action_control._physics_process(1)
	action_control._physics_process(1)
	
	assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==4, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==4, "size"+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	
	var action4 =Glob.getPollObject(ActionInfo,[Glob.FightMotion.Idle ,OS.get_ticks_msec(),["test"+id as String ,1],0*1000,ActionInfo.EXEMOD_NEWEST,-1])
	action4.not_generous_type.append(Glob.FightMotion.Idle)
	
	var input_array3 = [Glob.FightMotion.Idle ,OS.get_ticks_msec(),["test"+id as String ,1],0*1000,ActionInfo.EXEMOD_GENEROUS,-1]
	var action3 =Glob.getPollObject(ActionInfo,input_array3)
	action3.not_generous_type.append(Glob.FightMotion.Idle)
	
	var action_array =[action3 , action4]
	
	action_control.regist_group_actions(action_array,666)
	
	assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==4, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==6, "size"+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	
	action_control._physics_process(1)
	
	assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==5, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==6, "size"+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	
		#var action_control = BaseFightActionController.new()
	# var action_control = load("res://FrameWork/Fight/Action/FightActionMng.tscn").instance() 
	
	# for i in 3:
	# 	action_control.regist_action(Glob.FightMotion.Idle,0,ActionInfo.EXEMOD_SEQ,1,["test"+id as String ,1])
	# 	id=id+1
	# 	pass
	# pass
	
	# action_control.regist_action(Glob.FightMotion.Idle,0,ActionInfo.EXEMOD_GENEROUS,1,["test"+id as String ,1])
	
	# assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==4, "size"+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	
	# for i in 3:
	# 	action_control.regist_action(Glob.FightMotion.Idle,0,ActionInfo.EXEMOD_SEQ,1,["test"+id as String ,1])
	# 	id=id+1
	# 	pass
	
	# for i in 7:
	# 	action_control._physics_process(1)		
		
	# assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==4, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	# assert_true(action_control._current_action.execution_mod == ActionInfo.EXEMOD_SEQ, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	# assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==7, "size"+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	
	
	pass



#测试不同exemod类型的
func test_action_newest():
	
	#var action_control = BaseFightActionController.new()
	var action_control = load("res://FrameWork/Fight/Action/FightActionMng.tscn").instance() as FightActionMng
	
	add_child(action_control)
	
	action_control.get_handler_by_handling_type(Glob.ActionHandlingType.Movement).MAX_ACTION_ARRAY_SIZE=10000
	
	var instanceArray =[]
	for i in 100:
		action_control.regist_action(Glob.FightMotion.Idle,0,ActionInfo.EXEMOD_NEWEST,-1,["test"+id as String ,1])
		id=id+1
		pass
		
		
	assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==0, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==100, "size"+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	
	for i in 200:
		action_control._physics_process(1)
	assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==100, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==100, "size"+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	
	for i in 5:
		action_control.regist_action(Glob.FightMotion.Idle,0,ActionInfo.EXEMOD_SEQ,-1,["test"+id as String ,1])
		id=id+1
		pass
	assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==100, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==105, "size"+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	
	for i in 200:
		action_control._physics_process(1)
	assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==105, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==105, "size"+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	
	for i in 5:
		action_control.regist_action(Glob.FightMotion.Idle,0,ActionInfo.EXEMOD_SEQ,-1,["test"+id as String ,1])
		id=id+1
		pass
	assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==105, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==110, "size"+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	
	action_control.regist_action(Glob.FightMotion.Idle,0,ActionInfo.EXEMOD_INTERUPT,-1,["test"+id as String ,1])
	
	assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==110, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==111, "size"+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	
	for i in 200:
		action_control._physics_process(1)
	assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==111, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==111, "size"+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	
#简单的流程测试
func test_action_control():
	
	var action_control = load("res://FrameWork/Fight/Action/FightActionMng.tscn").instance()
	add_child(action_control)
	var instanceArray =[]
	for i in 100:
		action_control.regist_action(Glob.FightMotion.Idle,0,ActionInfo.EXEMOD_SEQ,-1,["test"+id as String ,1])
		id=id+1
		pass
	
	assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==100, "")
	
	for i in 200:
		action_control._physics_process(1)
	assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==100, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	
	for i in 5:
		action_control.regist_action(Glob.FightMotion.Idle,0,ActionInfo.EXEMOD_SEQ,-1,["test 10"+id as String ,1])
		id=id+1
	assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==105, "get size "+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==100, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	
	for i in 10:
		action_control._physics_process(1)
	
	assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==105, "get size "+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==105, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	
	for i in 5:
		action_control.regist_action(Glob.FightMotion.Idle,0,ActionInfo.EXEMOD_SEQ,-1,["test 10"+id as String ,1])
		id=id+1
	assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==6, "get size "+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==1, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	
	for i in 30:
		action_control._physics_process(1)
	
	assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==6, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	
	assert_null(action_control.get_current_action(Glob.ActionHandlingType.Movement))

func test_group_action():
	
	var action_control = load("res://FrameWork/Fight/Action/FightActionMng.tscn").instance()
	add_child(action_control)
	
	# var pre =pool.instance([Glob.FightMotion.Attack_Mid_Pre,OS.get_ticks_msec(),["test"+id as String ,1],0,ActionInfo.EXEMOD_SEQ])
	# var ing =pool.instance([Glob.FightMotion.Attack_Mid_In,OS.get_ticks_msec(),["test"+id as String ,1],0,ActionInfo.EXEMOD_SEQ])
	# var after =pool.instance([Glob.FightMotion.Attack_Mid_After,OS.get_ticks_msec(),["test"+id as String ,1],0,ActionInfo.EXEMOD_SEQ])
	# var attack_mid_array = [pre,ing,after]
	# action_control.regist_group_actions(attack_mid_array,action_control.next_group_id(),ActionInfo.EXEMOD_NEWEST)
	
	# var pre2 =pool.instance([Glob.FightMotion.Attack_Mid_Pre,OS.get_ticks_msec(),["test"+id as String ,1],0,ActionInfo.EXEMOD_SEQ])
	# var ing2 =pool.instance([Glob.FightMotion.Attack_Mid_In,OS.get_ticks_msec(),["test"+id as String ,1],0,ActionInfo.EXEMOD_SEQ])
	# var after2 =pool.instance([Glob.FightMotion.Attack_Mid_After,OS.get_ticks_msec(),["test"+id as String ,1],0,ActionInfo.EXEMOD_SEQ])
	# var attack_mid_array2 = [pre2,ing2,after2]
	# action_control.regist_group_actions(attack_mid_array2,action_control.next_group_id(),ActionInfo.EXEMOD_NEWEST)
	
	# assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==3, "get size "+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	# assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==0, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	
	# for i in 6:
	# 	action_control._physics_process(1)
		
	# assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==3, "get size "+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	# assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==3, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)

	# var pre3 =pool.instance([Glob.FightMotion.Attack_Mid_Pre,OS.get_ticks_msec(),["test"+id as String ,1],0,ActionInfo.EXEMOD_SEQ])
	# var ing3 =pool.instance([Glob.FightMotion.Attack_Mid_In,OS.get_ticks_msec(),["test"+id as String ,1],0,ActionInfo.EXEMOD_SEQ])
	# var after3 =pool.instance([Glob.FightMotion.Attack_Mid_After,OS.get_ticks_msec(),["test"+id as String ,1],0,ActionInfo.EXEMOD_SEQ])
	# var attack_mid_array3= [pre3,ing3,after3]
	# action_control.regist_group_actions(attack_mid_array3,action_control.next_group_id(),ActionInfo.EXEMOD_NEWEST)

	# assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==6, "get size "+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	# assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==3, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	
	# var seq1 =pool.instance([Glob.FightMotion.Idle,OS.get_ticks_msec(),["test"+id as String ,1],0,ActionInfo.EXEMOD_SEQ])
	# action_control.regist_actioninfo(seq1)
	
	# assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==4, "get size "+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	# assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==3, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	
	
	# action_control.regist_group_actions(_create_attack(),action_control.next_group_id(),ActionInfo.EXEMOD_NEWEST)
	
	# assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==7, "get size "+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	# assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==3, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	
	
	# var interupt =pool.instance([Glob.FightMotion.Idle,OS.get_ticks_msec(),["test"+id as String ,1],0,ActionInfo.EXEMOD_INTERUPT])
	# action_control.regist_actioninfo(interupt)
	
	# assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==4, "get size "+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	# assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==3, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	
	# action_control.regist_group_actions(_create_attack(),action_control.next_group_id(),ActionInfo.EXEMOD_NEWEST)
	
	# assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==7, "get size "+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	# assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==3, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	
	# for i in 7:
	# 	action_control._physics_process(1)
	
	# assert_true(action_control._current_action.execution_mod ==ActionInfo.EXEMOD_GENEROUS, "mode "+action_control._current_action.execution_mod as String)
	# assert_true(action_control._current_action.state ==ActionInfo.STATE_ING, "mode "+action_control._current_action.state as String)
	# assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==6, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	
	
	# action_control.regist_group_actions(_create_attack(),action_control.next_group_id(),ActionInfo.EXEMOD_NEWEST)
	
	# assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==10, "get size "+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	# assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==7, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	
	# for i in 6:
	# 	action_control._physics_process(1)
	
	# assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==10, "get size "+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	# assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==10, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)

	# action_control.regist_group_actions(_create_attack(),action_control.next_group_id(),ActionInfo.EXEMOD_SEQ)
	# action_control.regist_group_actions(_create_attack(),action_control.next_group_id(),ActionInfo.EXEMOD_SEQ)	
	
	# assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==16, "get size "+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	# assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==10, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
		
	# for i in 5:
	# 	action_control._physics_process(1)
		
	# assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==16, "get size "+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	# assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==13, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	
	
	# for i in 10:
	# 	action_control._physics_process(1)
		
	# assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==16, "get size "+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	# assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==16, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	
	# action_control.regist_group_actions(_create_attack(),action_control.next_group_id(),ActionInfo.EXEMOD_GENEROUS)
	# action_control.regist_group_actions(_create_attack(),action_control.next_group_id(),ActionInfo.EXEMOD_SEQ)	
	
	# assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==22, "get size "+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	# assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==19, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	
	# for i in 1:
	# 	action_control._physics_process(1)
		
	# assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==22, "get size "+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	# assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==19, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
		
	# action_control.regist_group_actions(_create_attack(),action_control.next_group_id(),ActionInfo.EXEMOD_GENEROUS)	
	
	# assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==25, "get size "+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	# assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==19, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	
	
	# action_control.regist_group_actions(_create_attack(),action_control.next_group_id(),ActionInfo.EXEMOD_GENEROUS)	
	
	# assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==28, "get size "+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	# assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==19, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	
	# for i in 4 :
	# 	action_control._physics_process(1)
		
	# assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==28, "get size "+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	# assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==25, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	
	# for i in 1 :
	# 	action_control._physics_process(1)
	
	# assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==28, "get size "+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	# assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==26, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	
	# for i in 10 :
	# 	action_control._physics_process(1)
	
	# assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==28, "get size "+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	# assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==28, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	
	# action_control.regist_group_actions(_create_attack(),action_control.next_group_id(),ActionInfo.EXEMOD_NEWEST)	
	
	# assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==31, "get size "+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	# assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==28, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	
	# action_control.regist_group_actions(_create_attack(),action_control.next_group_id(),ActionInfo.EXEMOD_NEWEST)
	
	# assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==31, "get size "+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	# assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==28, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	
	# for i in 1 :
	# 	action_control._physics_process(1)
		
	# action_control.regist_group_actions(_create_attack(),action_control.next_group_id(),ActionInfo.EXEMOD_NEWEST)
	# assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==34, "get size "+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	# assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==28, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)
	
	
	# for i in 4 :
	# 	action_control._physics_process(1)
		
	# assert_true(action_control.get_action_array(Glob.ActionHandlingType.Movement).size() ==34, "get size "+action_control.get_action_array(Glob.ActionHandlingType.Movement).size() as String)
	# assert_true(action_control.get_current_index(Glob.ActionHandlingType.Movement) ==31, "current index "+action_control.get_current_index(Glob.ActionHandlingType.Movement) as String)

func test_create_group():
	var action_control = load("res://FrameWork/Fight/Action/FightActionMng.tscn").instance()
	add_child(action_control)
	
	#var action =action_control._create_attack_action([Glob.FightMotion.Attack_Mid_Pre,Glob.FightMotion.Attack_Mid_In,Glob.FightMotion.Attack_Mid_After],[1,2,3])
	
	
	
func _create_attack():
	var pool = Glob.PoolDict.get(ActionInfo) as ObjPool
	var pre =pool.instance([Glob.FightMotion.Attack_Mid_Pre,OS.get_ticks_msec(),["test"+id as String ,1],0,ActionInfo.EXEMOD_SEQ])
	var ing =pool.instance([Glob.FightMotion.Attack_Mid_In,OS.get_ticks_msec(),["test"+id as String ,1],0,ActionInfo.EXEMOD_SEQ])
	var after =pool.instance([Glob.FightMotion.Attack_Mid_After,OS.get_ticks_msec(),["test"+id as String ,1],0,ActionInfo.EXEMOD_GENEROUS])
	var attack_mid_array = [pre,ing,after]
	
	return attack_mid_array
