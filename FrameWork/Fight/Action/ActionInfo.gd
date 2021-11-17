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
var action_end_time;
var action_duration_ms;

var param;#如果是 run/move 指令，保存方向向量

var _base_action_obj:BaseAction

func get_base_action()->BaseAction:
	
	if _base_action_obj==null:
		_base_action_obj = FightBaseActionMng.get_by_base_id(base_action)
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
	action_end_time=null
	param=null
	state = STATE_NULL;
	is_loop= false
	execution_mod =EXEMOD_NEWEST
	group_id = -1
	not_generous_type = []
	_base_action_obj = null
	pass
