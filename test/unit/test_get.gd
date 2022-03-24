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


func test_prototype():
	
	var pa = PrototypeA.new("a")
	var pb = PrototypeA.new("b")
	
	var ca = ClassB.new("class_b")
	
	pa.methoA()
	pa.methoB()
	pb.methoA()
	pb.methoB()
	ca.methoA()
	ca.methoB()	
	
	pb.__prototype = pa
	
	
	pa.methoA()
	pa.methoB()
	pb.methoA()
	pb.methoB()
	ca.methoA()
	ca.methoB()	
	
	ca.__prototype = pa
	
	
	pa.methoA()
	pa.methoB()
	pb.methoA()
	pb.methoB()
	ca.methoA()
	ca.methoB()	

func test_match():
	var a= 5
	match a:
		
		4:
			print(4)
			continue	
		5:
			print(5)
			continue
	
	
	pass
