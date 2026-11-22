# 发放阵营免伤战袍与双槽解耦长矛（1号位击球长矛 + 2号位 Lunge II 突进短矛）
$item replace entity @s armor.chest with minecraft:leather_chestplate[custom_data={sc_kit:1b},item_name={text:"$(name)战袍",color:"$(color)",italic:false},dyed_color=$(c),unbreakable={},enchantments={"sc:pvp_guard":1},enchantment_glint_override=false,tooltip_display={hidden_components:["minecraft:enchantments","minecraft:dyed_color","minecraft:unbreakable","minecraft:attribute_modifiers"]}]
$item replace entity @s armor.feet with minecraft:leather_boots[custom_data={sc_kit:1b},item_name={text:"$(name)战靴",color:"$(color)",italic:false},dyed_color=$(c),unbreakable={},tooltip_display={hidden_components:["minecraft:dyed_color","minecraft:unbreakable","minecraft:attribute_modifiers"]}]

function sc:player/refill_spears
