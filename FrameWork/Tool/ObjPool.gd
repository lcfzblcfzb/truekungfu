class_name ObjPool
extends Object

#保存对象的数组
var pool_array =[]
#没啥用TODO
var POOL_SIZE = 100

#POOL中保存的类
var class_type :GDScript

func _init(c_type,maxSize=100):
	POOL_SIZE = maxSize
	class_type = c_type 
pass

#实例化对象
func instance(param:Array)->IPoolAble:
	
	if pool_array.size()>0:
		var old_obj = pool_array.pop_back()
		old_obj._init(self,param)
		return old_obj
	else:
		var inst = class_type.new(self,param)
		
		if ! inst is IPoolAble:
			push_warning("ObjectPool is instancing obj that is not poolable")
		return inst
#返回pool
func returnToPool(o):
	pool_array.append(o)

#可以存入pool中 的对象
class IPoolAble:
	#对象池
	var pool :ObjPool
	func _init(p,param:=null):
		pool = p
		pass
	
	#无用的对象调用此方法返回对象池中
	func dead():
		_clean()
		pool.returnToPool(self)
		pass
	
	#abstract method
	#由具体的类实现清空，返回池子
	func _clean():
		
		pass
		
