class_name Glob
extends Node

const dPi = 2*PI
const hPi = PI/2
#玩家初始背包上限
const Player_Item_Slot_Number = 12

#ActionHandler 的处理类型。用来区分不同的action handler
enum ActionHandlingType{
	# 关于角色移动的分类
	Movement=1,
	
	#关于角色 各种动作的分类（除了移动）
	Action=2,
}	

#TODO 动态创建 ObjPool发
#通过get 方法 检测一遍 如果没找到就NEW 一个

enum EventType{
	
	NewAction,
	Move,
	AI_Event
	
}

#standar animated charactor 上的 animationplayer 中 调用的方法
#主要用来改变weapon_box 和 hurt_box 状态的
enum AnimationMethodType{
	AttackCiStart=100,
	AttackCiEnd=101,
	AttackPiStart=102,
	AttackPiEnd=103,
	AttackSaoStart=104,
	AttackSaoEnd=105,
	
	BlockStart =200,
	BlockEnd =201,
	
	RollStart =301,
	RollEnd =302,
	
	DodgeStart =401,
	DodgeEnd =402,
}


#伤害 类型。
enum DamageType{
	Ci = 1,# 只可以被格挡 或 闪避 对应
	Pi = 2,# 可以被格挡 或 翻滚 对应
	Sao = 3# 只可以被格挡 
}

#防御类型
enum CounterDamageType{
	AutoBlock=1,
	Block =2, #格挡
	Dodge =3,# 闪避
	Rolling =4#翻滚
}

#角色骨骼类型-- 用户统一动画的制作。同种类型的骨骼可以适配同一套动画
enum ChatactorSkeletalType{
	Normal=0,#普通正常成年男子体型
	Fat=1# 胖的体系（肚子大 腿短 比较滑稽）
}

enum CampEnum {
	Good,
	Bad,
	Neutral,#以上可以互相攻击
	Harmless#任何一方都无法攻击
}

#角色样式
enum CharactorEnum{
	Daoshi=100,
	Rusheng=101,
	Fatguy=200,
}
#装备枚举（base_id)
enum GearEnum{
	
	Fist = 600,
	DuanDao=601,
	DuanJian=602,
	
}

#既是 base_weapon_id
enum WeaponEnum{
	
	Fist =10,
	DuanDao =20,
	DuanJian =30,
	
}

#武器类型（武器大类)
enum WeaponType{
	Fist=0,
	Dao=1,
	Jian=2,
	Qiang=3,
	Mao=4
	
}

#装备部位(并非具体的部位）
enum GearSlot{
	Head =1 ,
	Body =2,
	Hip =3,
	Hand =4,
	Foot =5,
	Weapon =6
}

#道具的类型
enum OutfitUseType{
	#不可使用
	NoUse=0
	#可装备物品
	Gear =1
	# 可使用的道具
	Outfit = 2
}

#base outfit
enum BaseOutfitType{
	Null=-1
	Money = 1
	BookBlue =2
	Apple = 3
	
	Duandao =1000
	Duanjian=1001
	
	Healing = 2000
	
}


#枚举类型
enum WuxueEnum{
	
	Nope=0,
	Sanjiaomao=1,
	Taijijian=2
	
}


# key-> type_name, value: {  "min_idx"-> the type's starting index , "max_idx"->the type's ending index}
const AttributeType={
	"DurationMs":{
		"min_idx":300,
		"max_idx":399
	}
}

#属性类型
enum CharactorAttribute{
	Block = 100,#number
	BlockRegen =101,# number/second; 通过 attributeMng get 的是 number/frame_time
	Stamina =102,#number
	StaminaRegen =103,# number/second ; 通过 attributeMng get 的是 number/frame_time
	
	WalkSpeed = 200,#pix/second
	RunSpeed =201,#pix/second
	JumpSpeed =202,#pix/second
	RollSpeed =203, #pix/second
	ClimbSpeed = 204,
	AttackMoveSpeed = 205,
	
	AttackCiDuration = 300,#second
	AttackPiDuration =301,#second
	AttackSaoDuration =302,#second
	PreBlockDuration =303,#second
	PostBlockDuration = 304,
	CancelDuration = 305,
	RollingDuration = 306,
	PrepareDuration = 307,
	UnPrepareDuration = 308,
	HoldingDuration = 309,
	
	BlockStamina = 400,#number
	RollStamina =401,#number
	RunStamina =402,#value per second
	JumpStamina =403,#number
	AttackCiStamina =404,#number
	AttackPiStamina =405,#number
	AttackSaoStamina =406,#number
	
	AttackCiDamage = 500,
	AttackSaoDamage = 501,
	AttackPiDamage = 502,
	BlockReduceDamage= 503
	
}

#返回一个介于0-》2PI 之间的角度
static func normalizeAngle(angle:float):
	var absAngle =abs(angle)
	if(absAngle>dPi||angle<0):
		angle = fposmod(angle,dPi)
	
	return angle
#详情见godot文档。节点在屏幕上的坐标章节 
static func getCameraPosition(node:Node2D)->Vector2:
	
#	print(node.get_viewport_transform(),node.get_global_transform(),node.position)
	
	return node.get_viewport_transform() * (node.get_global_transform() * node.position)

#从text文件中读取json 并保存为json对象
static func load_json_file(path):
	"""Loads a JSON file from the given res path and return the loaded JSON object."""
	var file = File.new()
	file.open(path, file.READ)
	var text = file.get_as_text()
	var result_json = JSON.parse(text)
	if result_json.error != OK:
		print("[load_json_file] Error loading JSON file '" + str(path) + "'.")
		print("\tError: ", result_json.error)
		print("\tError Line: ", result_json.error_line)
		print("\tError String: ", result_json.error_string)
		return null
	var obj = result_json.result
	return obj

# 武 动作枚举（抽象动作，每个特定的武术会有自己的实现)
enum WuMotion{
	
	Idle,
	Walk,
	Run,
	Holding,
	Stunned,
	JumpUp,
	JumpDown,
	Hanging,
	HangingClimb,
	Attack,
	Attack_Pi,
	Block,
	Defend,
	Prepared,
	Unprepared,
	Switch,
	Rolling,
	Cancel,
	PostBlock,
	
	Attack_Up,
	Attack_Mid,
	Attack_Bot,
	
	Attack_U2M,
	Attack_U2B,
	Attack_M2U,
	Attack_M2B,
	Attack_B2M,
	Attack_B2U,
	
	Defend_Up,
	Defend_Mid,
	Defend_Bot
	
}

#动作类型
enum FightMotionType{
	Move=1,
	Action=2,
	AttackAction=3,
	DefendAction=4,
}


#动画ID名称
enum FightMotion{
	
	Idle =154,
	Walk=155,
	Run=156,
	Holding=157,
	Idle2Run=158,
	Run2Idle=159,
	Stunned =160,
	JumpUp =161,
	JumpDown =162,
	Climb = 163,
	Hanging = 164,
	HangingClimb = 165,
	Attack_Ci = 166,
	Defend = 167,
	Prepared = 168,
	Unprepared = 169,
	PreAttack = 170,
	Rolling = 171,
	Blocking = 172,
	Attack_Pi = 173,
	Dodge = 174,
	Attack_Sao=175,
	Canceled  = 176,
	Pre_Block = 177,
	Post_Block= 178,
	
	Attack_Up_Pre=100,
	Attack_Up_In=101,
	Attack_Up_After=102,
	Attack_Mid_Pre=103,
	Attack_Mid_In=104,
	Attack_Mid_After=105,
	Attack_Bot_Pre=106,
	Attack_Bot_In=107,
	Attack_Bot_After=108,
	
	HeavyAttack_U_Pre=109,
	HeavyAttack_U_In=110,
	HeavyAttack_U_After=111,
	HeavyAttack_M_Pre=112,
	HeavyAttack_M_In=113,
	HeavyAttack_M_After=114,
	HeavyAttack_B_Pre=115,
	HeavyAttack_B_In=116,
	HeavyAttack_B_After=117,
	
	HeavyAttack_U2M_Pre=118,
	HeavyAttack_U2M_In=119,
	HeavyAttack_U2M_After=120,
	HeavyAttack_U2B_Pre=121,
	HeavyAttack_U2B_In=122,
	HeavyAttack_U2B_After=123,
	
	HeavyAttack_M2B_Pre=124,
	HeavyAttack_M2B_In=125,
	HeavyAttack_M2B_After=126,
	HeavyAttack_M2U_Pre=127,
	HeavyAttack_M2U_In=128,
	HeavyAttack_M2U_After=129,
	
	HeavyAttack_B2M_Pre=130,
	HeavyAttack_B2M_In=131,
	HeavyAttack_B2M_After=132,
	HeavyAttack_B2U_Pre=133,
	HeavyAttack_B2U_In=134,
	HeavyAttack_B2U_After=135,
	
	Def_Up_Pre=136,
	Def_Up_In=137,
	Def_Up_After=138,
	Def_Mid_Pre=139,
	Def_Mid_In=140,
	Def_Mid_After=141,
	Def_Bot_Pre=142,
	Def_Bot_In=143,
	Def_Bot_After=144,
	
	HeavyDef_U_Pre=145,
	HeavyDef_U_In=146,
	HeavyDef_U_After=147,
	
#	HeavyDef_U2M_Pre=148,
#	HeavyDef_U2M_In=149,
#	HeavyDef_U2M_After=150,
#	HeavyDef_U2B_Pre=151,
#	HeavyDef_U2B_In=152,
#	HeavyDef_U2B_After=153,
	
	HeavyDef_M_Pre=148,
	HeavyDef_M_In=149,
	HeavyDef_M_After=150,
#	HeavyDef_M2U_Pre=157,
#	HeavyDef_M2U_In=158,
#	HeavyDef_M2U_After=159,
#	HeavyDef_M2B_Pre=160,
#	HeavyDef_M2B_In=100,
#	HeavyDef_M2B_After=100,
	
	HeavyDef_B_Pre=151,
	HeavyDef_B_In=152,
	HeavyDef_B_After=153,
#	HeavyDef_B2M_Pre=100,
#	HeavyDef_B2M_In=100,
#	HeavyDef_B2M_After=100,
#	HeavyDef_B2U_Pre=100,
#	HeavyDef_B2U_In=100,
#	HeavyDef_B2U_After=100
}

class RandomTool:
	
	static func get_random(list:Array):
		var rand_num = floor(rand_range(0,list.size()))
		return list[rand_num]		
	
	
