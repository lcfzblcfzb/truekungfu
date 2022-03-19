extends "res://addons/gut/test.gd"
func before_each():
	gut.p("ran setup", 2)

func after_each():
	gut.p("ran teardown", 2)

func before_all():
	gut.p("ran run setup", 2)

func after_all():
	gut.p("ran run teardown", 2)

func test_get_override():
	
	var ie = IntEntity.new()
	ie.id = 1.0001
	assert_eq(ie.id ,1)
	ie.id = 2
	assert_eq(ie.id ,2)
	ie.id = 1.6
	assert_eq(ie.id ,2)
