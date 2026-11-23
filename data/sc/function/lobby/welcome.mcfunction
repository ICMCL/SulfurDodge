tag @s add sc_seen
execute in minecraft:overworld if block 0 69 -16 emerald_block unless entity @s[tag=sc_ingame] run function sc:lobby/arrive
gamemode adventure @s
tellraw @s [{text:"[硫方涂境] ",color:"gold",bold:true},{text:"欢迎来到樱庭云阶浮岛！走进红/蓝樱亭选队，右键讲台调整规则，前排回廊可露天直视全场。",color:"white",bold:false}]
