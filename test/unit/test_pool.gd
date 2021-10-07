extends "res://addons/gut/test.gd"
func before_each():
	gut.p("ran setup", 2)

func after_each():
	gut.p("ran teardown", 2)

func before_all():
	gut.p("ran run setup", 2)

func after_all():
	gut.p("ran run teardown", 2)

func test_pool():
	
	var pool =ObjPool.new(FightActionController.ActionInfo)
	var instanceArray =[]
	for i in 100:
		
		var instanceA = pool.instance([i,OS.get_ticks_msec(),"TEST" +i as String])
		instanceArray.append(instanceA)
		pass
	
	assert_true(pool.pool_array.size() ==0, "")
	for i in 10:
		var obj =instanceArray.pop_back()
		obj.dead()
	
	assert_true(pool.pool_array.size() ==10, "size 10")
	
	for i in 5:
		var instanceA = pool.instance([i,OS.get_ticks_msec(),"TEST%"+ i as String])
		instanceArray.append(instanceA)
	assert_true(pool.pool_array.size() ==5, "size 5")
	
