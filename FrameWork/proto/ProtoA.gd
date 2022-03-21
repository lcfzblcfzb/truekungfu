class_name PrototypeA

var __prototype:PrototypeA

var name

func _init(n):
	name = n

func methoA():
	if __prototype:
		__prototype.methoA()
		return
	print("methodA from ",name)	


func methoB():
	if __prototype:
		__prototype.methoB()
		return
	print("methodB from ",name)	
