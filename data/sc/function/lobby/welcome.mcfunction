tag @s add sc_seen
execute in minecraft:overworld if block -3 73 -17 emerald_block unless entity @s[tag=sc_ingame] run function sc:lobby/arrive
gamemode adventure @s
tellraw @s [{text:"[硫方涂境] ",color:"gold",bold:true},{text:"欢迎来到上下双层弹射竞技场！北侧看台踩区选队与右键讲台设置，南侧玻璃地板可直接俯视下方战场。",color:"white",bold:false}]
