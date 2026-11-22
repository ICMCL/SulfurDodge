# 保留参赛身份和队伍，仅退出本小局。选队大厅就是观战区。
tag @s remove sc_alive
tag @s add sc_spec
scoreboard players set @s sc_death 0
scoreboard players set @s sc_burn_warn 0
scoreboard players set @s sc_burn_cd 0
scoreboard players set @s sc_charging 0
scoreboard players set @s sc_charge_dur 0
clear @s
gamemode adventure @s
effect clear @s
effect give @s minecraft:instant_health 1 10 true
effect give @s minecraft:saturation 2 4 true
effect give @s minecraft:resistance 2 4 true
function sc:lobby/arrive
