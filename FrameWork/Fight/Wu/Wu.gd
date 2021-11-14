extends Node2D


func switch_wu(type):
	
	pass


func _on_FightController_NewFightMotion(new_motion:NewActionEvent):
	var global_id 
	
	var attack_begin_time = new_motion.action_begin_time
	var heavyAttackThreshold =500
	if OS.get_ticks_msec()<=attack_begin_time+heavyAttackThreshold:
		#轻攻击
		#攻击 调用
		var byte = new_motion.last_byte
		if _is_attack_up_position(byte):
			#attack up
			#var name =Tool._map_action2animation(Tool.FightMotion.Attack_Up)
							
			var a_list =_create_attack_action([Tool.FightMotion.Attack_Up_Pre,Tool.FightMotion.Attack_Up_In,Tool.FightMotion.Attack_Up_After])
			
			regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_GROUP_NEWEST)

			pass
		elif _is_attack_mid_position(byte):
			#attack mid
			var a_list =_create_attack_action([Tool.FightMotion.Attack_Mid_Pre,Tool.FightMotion.Attack_Mid_In,Tool.FightMotion.Attack_Mid_After])
			
			regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_GROUP_NEWEST)

			#regist_action(Tool.FightMotion.Attack_Mid)
			pass
		elif _is_attack_bot_position(byte):
			#attack bot
			
			var a_list =_create_attack_action([Tool.FightMotion.Attack_Bot_Pre,Tool.FightMotion.Attack_Bot_In,Tool.FightMotion.Attack_Bot_After])
			
			regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_GROUP_NEWEST)

			#regist_action(Tool.FightMotion.Attack_Bot)
			pass
		
		elif _is_def_bot(byte):
			
			var a_list =_create_attack_action([Tool.FightMotion.Def_Bot_Pre,Tool.FightMotion.Def_Bot_In,Tool.FightMotion.Def_Bot_After])
			
			regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_GROUP_NEWEST)

		elif _is_def_mid(byte):
			
			var a_list =_create_attack_action([Tool.FightMotion.Def_Mid_Pre,Tool.FightMotion.Def_Mid_In,Tool.FightMotion.Def_Mid_After])
			
			regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_GROUP_NEWEST)

		elif _is_def_up(byte):
			
			var a_list =_create_attack_action([Tool.FightMotion.Def_Up_Pre,Tool.FightMotion.Def_Up_In,Tool.FightMotion.Def_Up_After])
			
			regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_GROUP_NEWEST)

		else:
			regist_action(Tool.FightMotion.Idle)
			jisu.change_movable_state(Vector2.ZERO,FightKinematicMovableObj.ActionState.Idle)
			#defend todo
			pass
	else:
		#蓄力重攻击
		
		if moving_position_array.size()<=0:
			#nothing happen
			regist_action(Tool.FightMotion.Idle)
			jisu.change_movable_state(Vector2.ZERO,FightKinematicMovableObj.ActionState.Idle)

			return
		elif moving_position_array.size()==1:
			var byte = moving_position_array.pop_back()
			if _is_attack_up_position(byte):
				#heavy_attack_up
				var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_U_Pre,Tool.FightMotion.HeavyAttack_U_In,Tool.FightMotion.HeavyAttack_U_After])
			
				regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_GROUP_NEWEST)
				
			elif _is_attack_mid_position(byte):
				#heavy_attack_mid
				var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_M_Pre,Tool.FightMotion.HeavyAttack_M_In,Tool.FightMotion.HeavyAttack_M_After])
			
				regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_GROUP_NEWEST)
			elif _is_attack_bot_position(byte):
				#heavy_attack_bot
				var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_B_Pre,Tool.FightMotion.HeavyAttack_B_In,Tool.FightMotion.HeavyAttack_B_After])
			
				regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_GROUP_NEWEST)
		else:
			var startPos = moving_position_array.pop_front()
			var backPos = moving_position_array.pop_back()
			var resultByte=  startPos + backPos
			if startPos>backPos:
				resultByte += from_byte;
			
			if _is_attack_up_position(resultByte):
				#heavy_attack_up
				var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_U_Pre,Tool.FightMotion.HeavyAttack_U_In,Tool.FightMotion.HeavyAttack_U_After])
			
				regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_GROUP_NEWEST)
				pass
			elif _is_attack_u2m(resultByte):
				#heavy_attack_up
				var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_U2M_Pre,Tool.FightMotion.HeavyAttack_U2M_In,Tool.FightMotion.HeavyAttack_U2M_After])
			
				regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_GROUP_NEWEST)
				pass
			elif _is_attack_u2b(resultByte):
				#h_a_u2b
				
				var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_U2B_Pre,Tool.FightMotion.HeavyAttack_U2B_In,Tool.FightMotion.HeavyAttack_U2B_After])
			
				regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_GROUP_NEWEST)
				
				pass
			elif _is_attack_m2u(resultByte):
				#h_a_m2u
				
				var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_M2U_Pre,Tool.FightMotion.HeavyAttack_M2U_In,Tool.FightMotion.HeavyAttack_M2U_After])
			
				regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_GROUP_NEWEST)
				
				pass
			elif _is_attack_mid_position(resultByte):
				#h_a_m
				
				var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_M_Pre,Tool.FightMotion.HeavyAttack_M_In,Tool.FightMotion.HeavyAttack_M_After])
			
				regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_GROUP_NEWEST)

				pass
			elif _is_attack_m2b(resultByte):
					#h_a_m2b
				
				var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_M2B_After,Tool.FightMotion.HeavyAttack_M2B_In,Tool.FightMotion.HeavyAttack_M2B_After])
			
				regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_GROUP_NEWEST)

				pass
					
			elif _is_attack_b2u(resultByte):
					#h_a_b2u
										
				var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_B2U_Pre,Tool.FightMotion.HeavyAttack_B2U_In,Tool.FightMotion.HeavyAttack_B2U_After])
			
				regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_GROUP_NEWEST)
					
				pass
			elif _is_attack_b2m(resultByte):
					#h_a_b2m
					
				var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_B2M_Pre,Tool.FightMotion.HeavyAttack_B2M_In,Tool.FightMotion.HeavyAttack_B2M_After])
			
				regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_GROUP_NEWEST)
				
				pass
			elif _is_attack_bot_position(resultByte):
				#h_a_b
				
				var a_list =_create_attack_action([Tool.FightMotion.HeavyAttack_B_Pre,Tool.FightMotion.HeavyAttack_B_In,Tool.FightMotion.HeavyAttack_B_After])
			
				regist_group_actions(a_list,global_id,ActionInfo.EXEMOD_GROUP_NEWEST)
				
				pass
			else:
				#无效的指令了
				regist_action(Tool.FightMotion.Idle)
				jisu.change_movable_state(Vector2.ZERO,FightKinematicMovableObj.ActionState.Idle)

				pass
		
		pass
