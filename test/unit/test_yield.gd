extends "res://addons/gut/test.gd"
func before_each():
	gut.p("ran setup", 2)

func after_each():
	gut.p("ran teardown", 2)

func before_all():
	gut.p("ran run setup", 2)

func after_all():
	gut.p("ran run teardown", 2)

func test_yield():
	
	for i in 10:
		yield_time(i)
		print(i as String)


func test_yield2():
	
	for i in 10:
		yield(get_tree().create_timer(1),"timeout")
		print(i as String)

	
func yield_time(i):
	
	yield(get_tree().create_timer(5),"timeout")
	print("time"+i as String)
