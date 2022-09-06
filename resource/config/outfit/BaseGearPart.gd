extends Resource

#所属部位
export(StandarCharactor.CharactorBodySlotEnum) var part
#层次(前后,Z-index)  [1-10] 作为基础装饰层 [11-20] 作为上层装饰层  [21>] 作为最上层
export(int) var z_index_default
#图像资源
export(Resource) var texture

#图像偏移
export(Vector2) var offset
