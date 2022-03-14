extends Node
class_name Log

const DEBUG_MODE = true
var LEVEL :int= 1

enum {
	ALL = 0,
	TRACE,	# 1
	AI,		# 2
	DEBUG,	# 3
	WARN,	# 4
	ERROR	# 5
}

# LOG LEVELS
# 0: All
# 1: TRACE
# 2: AI
# 3: DEBUG
# 4: WARN
# 5: ERROR / FATAL

const msg_sub_type = ["ALL  ", "TRACE", "AI   ", "DEBUG", "WARNING"]


func pr(level: int, log_msg, caller:String = "") -> void:
	if not DEBUG_MODE or level < LEVEL:
		return

	var msg = str(log_msg) + " -- \t\t\t\t[%s]"%caller
	msg = msg_sub_type[level] + " -- " + msg
	print(msg)


func err(err_msg, caller:String = "") -> void:

	var msg = str(err_msg) + ("\t\t\t\t[%s]"%caller)
	msg = "ERROR" + " -- " + msg
	print(msg)


func _ready() -> void:
	pr(3, "LOG READY")
