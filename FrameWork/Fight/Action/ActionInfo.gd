class_name ActionInfo 

extends ObjPool.IPoolAble	

	
const STATE_NULL=-1
const STATE_INITED=0
const STATE_ING=10
const STATE_ENDED=20
#代表动作 中断
const STATE_INTERUPTED=30
#代表动作 让出了
const STATE_PASSED=40
#是否循环播放
var is_loop = false
 
func _init(pool,params_array:Array).(pool):
	base_action=params_array[0]
	action_create_time = params_array[1]
	param =params_array[2]
	action_duration_ms = params_array[3]
	state = STATE_INITED
	if action_duration_ms <0:
		is_loop = true
	execution_mod = params_array[4]
	if params_array.size()>5:
		repeatation_allowed = params_array[5]
	else:
		repeatation_allowed = true
	
pass
#最普通的action方式，如果前一个action也是newest ，则会被覆盖
const EXEMOD_NEWEST =0
#按顺序排队执行
const EXEMOD_SEQ = 10
#抢先执行
const EXEMOD_INTERUPT =20
#允许同一组 以SEQ 方式进入队列。但是会被最新的action 所取消，和newest 性质一样
#const EXEMOD_GROUP_NEWEST =30
#添加的时候，不会去掉newest; 在轮到它执行的时刻，有新的结点出现，就让出给新的。可以设置not_generous_type过滤规则
const EXEMOD_GENEROUS =40


var group_id = -1
var not_generous_type = []
	
var execution_mod =EXEMOD_NEWEST
var group_exe_mod =null

#业务类型
var base_action;
#时间属性 --ms
var action_create_time;
var action_begin_time;
#记录 动作经历的时间。
#ATTENTION.有两种处理方法：记录一个结束时间的方法也是可行的。
#但是考虑到游戏系统的时间是一种资源，如果需要引入 时间加速、减速特性，使用pass_time 的方式更容易处理
var action_pass_time;
var action_duration_ms;
#是否支持重复的action 插入队列；若是false，若队列之前有两个is_bussiness_equal 一致的action ，后一个会被忽略
var repeatation_allowed ;

var param;#如果是 run/move 指令，保存方向向量

var _base_action_obj:BaseAction

func get_base_action()->BaseAction:
	
	if _base_action_obj==null:
		_base_action_obj = FightBaseActionDataSource.get_by_base_id(base_action)
	return _base_action_obj

#保存动作的释放状态。
#-1: NULL(未初始化，空的状态)
#0: 初始化 未开始
#10:进行中
#20:结束
var state = STATE_NULL setget _set_state

#进行一个简单的提示，并不强制要求 严格的状态机切换
func _set_state(s_to):
	
	match s_to:
		STATE_NULL:
			if state == STATE_INITED || state == STATE_ING:
				push_warning("FightControlActionStateShift NoLegal,from: to:")
			pass
		STATE_INITED:
			if state != STATE_NULL:
				push_warning("FightControlActionStateShift NoLegal,from: to:")
			pass
		STATE_ING:
			if state != STATE_INITED:
				push_warning("FightControlActionStateShift NoLegal,from: to:")
			pass
		STATE_ENDED:
			if state != STATE_ING:
				push_warning("FightControlActionStateShift NoLegal,from: to:")
			pass
		STATE_INTERUPTED:
			if state != STATE_ING:
				push_warning("FightControlActionStateShift NoLegal,from: to:")
			pass
		STATE_PASSED:
			if state == STATE_NULL:
				push_warning("FightControlActionStateShift NoLegal,from: to:")
			pass
	state = s_to
	pass

func _clean():
	base_action=null
	action_create_time=null
	action_begin_time=null
	action_duration_ms=null
	action_pass_time=null
	param=null
	state = STATE_NULL;
	is_loop= false
	execution_mod =EXEMOD_NEWEST
	group_id = -1
	not_generous_type = []
	_base_action_obj = null
	repeatation_allowed = null
	pass

# 是否业务层面上一样；只针对group_id=-1 (无分组类型)的action
# 比较内容：
# 1 base_action
# 2 action_duration_ms ：这个出去检测；不同时间的action 业务上可以是做同样的
# 3 param
# 4 execution_mod
# 5 not_generous_type
# 6 group_id  
func is_bussiness_equal(action:ActionInfo)->bool:
	
	#group_id 都要为 -1
	if action.group_id!= -1 or group_id!=-1:
		return false
	if action.base_action!= base_action:
		return false
	if action_duration_ms!=action.action_duration_ms:
		return false
	if	param!=action.param:
		return false
	if execution_mod!=action.execution_mod:
		return false
	if not_generous_type!= action.not_generous_type:
		return false
	return true
