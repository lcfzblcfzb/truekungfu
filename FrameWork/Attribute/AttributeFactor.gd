class_name AttributeFactor
extends ObjPool.IPoolAble

#参数影响attribute 的类型
enum Type{
	#设置base是 是替换值
	Base = 0,
	Bonus =1,
	BaseRate =2,
	BonusRate =3,
	AllRate =4
}
#上面的类型
var type:int
#影响的类型的值
var value:float
#所属的attribute对象
var _attribute

var applyer

func _init(pool,params_array:Array).(pool):
	
	if params_array.size()>=3:
		type = params_array[0]
		value = params_array[1]
		applyer = params_array[2]

#Overrided
func _clean():
	type = -1
	value = 0
	_attribute=null
	applyer = null
