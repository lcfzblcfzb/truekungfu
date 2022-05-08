extends Weapon

func getWeaponBox():
	return $weaponBox


func on_active(a):
	
	if a:
		var base_dmg = get_base_weapon().base_damage
		var attr_mng =  get_fight_cpn().attribute_mng as AttribugeMng
		
		attr_mng.get_attribute(Glob.CharactorAttribute.AttackCiDamage).add_factor(Glob.getPollObject(AttributeFactor,[AttributeFactor.Type.Base,base_dmg,self]))
		
		attr_mng.get_attribute(Glob.CharactorAttribute.AttackSaoDamage).add_factor(Glob.getPollObject(AttributeFactor,[AttributeFactor.Type.Base,base_dmg,self]))
		
		attr_mng.get_attribute(Glob.CharactorAttribute.AttackPiDamage).add_factor(Glob.getPollObject(AttributeFactor,[AttributeFactor.Type.Base,base_dmg,self]))
		
		attr_mng.get_attribute(Glob.CharactorAttribute.BlockReduceDamage).add_factor(Glob.getPollObject(AttributeFactor,[AttributeFactor.Type.Base,get_base_weapon().base_block,self]))
		
	else:
		var base_dmg = get_base_weapon().base_damage
		var attr_mng =  get_fight_cpn().attribute_mng as AttribugeMng
		
		var attr = attr_mng.get_attribute(Glob.CharactorAttribute.AttackCiDamage)
		var fac = attr.find_factor_by_applyer(self)
		if fac!=null:
			attr.remove_factor(fac)
			
		var attr_sao = attr_mng.get_attribute(Glob.CharactorAttribute.AttackSaoDamage)
		var fac_sao = attr_sao.find_factor_by_applyer(self)
		if fac_sao!=null:
			attr_sao.remove_factor(fac_sao)
			
		var attr_pi = attr_mng.get_attribute(Glob.CharactorAttribute.AttackPiDamage)
		var fac_pi = attr_pi.find_factor_by_applyer(self)
		if fac_pi!=null:
			attr_pi.remove_factor(fac_pi)
			
		var block_reduce = attr_mng.get_attribute(Glob.CharactorAttribute.BlockReduceDamage)
		var fac_block = block_reduce.find_factor_by_applyer(self)
		if fac_block!=null:
			block_reduce.remove_factor(fac_block)	
