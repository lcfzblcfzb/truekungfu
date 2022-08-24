extends Node
# date-time [level]:msg
export(String) var FormatString = "%s [%s]: %s"

export(String) var date_time_format="{year}-{month}-{day} {hour}:{minute}:{second}"

enum Level{
	Verbose=0,
	Debug=1,
	Info=2,
	Warn=3,
	Error=4,
	Fatal=5
}

func fatal(msg):
	write_log(Level.Fatal,msg)

func error(msg):
	write_log(Level.Error,msg)

func warn(msg):
	write_log(Level.Warn,msg)

func info(msg):
	write_log(Level.Info,msg)

func debug(msg):
	if OS.is_debug_build():
		write_log(Level.Debug,msg)

func write_log(level,msg:String):
	
	if msg.empty():
		return
	
	var time_stamp =OS.get_unix_time()
	#get local date time 
	var bias = OS.get_time_zone_info().bias*60
	time_stamp+=bias
	var date_time =OS.get_datetime_from_unix_time(time_stamp)
	var date = date_time_format.format(date_time)
	if level!=Level.Error and level !=Level.Fatal:
		push_warning(FormatString % [date,CommonTools.get_enum_key_name(Level,level),msg])
	else:
		push_error(FormatString % [date,CommonTools.get_enum_key_name(Level,level),msg])
	
func _ready():
	debug("test")
