class_name AttributeFactor
extends ObjPool.IPoolAble

#参数影响attribute 的类型
enum Type{
	Base = 0,
	Bonus =1,
	BaseRate =2,
	BonusRate =3,
	AllRate =4
}
#上面的类型
var type
#影响的类型的值
var value:float

var _attribute
var identifer:int
var identifer_desc :String

func _init(pool,params_array:Array).(pool):
	
	if params_array.size()>=4:
		type = params_array[0]
		value = params_array[1]
		identifer = params_array[2]
		identifer_desc = params_array[3]

#Overrided
func _clean():
	type = null
	value = 0
	_attribute=null
	identifer=0
	identifer_desc=""
