extends "res://addons/gut/test.gd"
func before_each():
	gut.p("ran setup", 2)

func after_each():
	gut.p("ran teardown", 2)

func before_all():
	gut.p("ran run setup", 2)

func after_all():
	gut.p("ran run teardown", 2)

func test_assert_eq_number_not_equal():
	
	assert_eq(1, 2, "Should fail.  1 != 2")

func test_assert_eq_number_equal():
	assert_eq('asdf', 'asdf', "Should pass")

func test_assert_true_with_true():
	assert_true(true, "Should pass, true is true")

func test_assert_true_with_false():
	assert_true(false, "Should fail")

func test_something_else():
	assert_true(false, "didn't work")
	
func test_array_slice():
	
	var list = [1,2,3,4,5,6]
	
	var list_01 = list.slice(0,0)
	
	var list_02 = list.slice(6,6)
	
	var list_03 = list.slice(5,6)
	
	var list_04 = list.slice(5,7)
	
	var list_05 = list.slice(1,3)
	
	var list_06 = list.slice(3,1)
	pass


func test_obj_pool():
	var obj =GlobVar.getPollObject(NewActionEvent,[])
	assert_true(obj is NewActionEvent)
	
	var obj2 =GlobVar.getPollObject(ActionInfo,[1,2,3,4,5])
	assert_true(obj2 is ActionInfo)
	
	var array=[]
	for i in 10:
		array.append(GlobVar.getPollObject(ActionInfo,[1,2,3,4,5]))
#	var fight_event=BaseFightEvent.new(ObjPool.new(BaseFightEvent),2,[])
	
	for a in array:
		
		a.dead()
	
	pass


func test_array_resize():
	
	var list = [1,2,3,4,5,6]
	
	list.resize(3)
	assert_eq(list.size(),3)
	list.resize(6)
	
	assert_eq(list.size(),6)
	pass
