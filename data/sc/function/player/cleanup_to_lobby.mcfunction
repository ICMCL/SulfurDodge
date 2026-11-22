# 恢复玩家原背包并传回主世界选队大厅
tag @s remove sc_ingame
tag @s remove sc_alive
tag @s remove sc_spec
tag @s remove sc_on_hazard
tag @s remove sc_on_safe
scoreboard players set @s sc_death 0
scoreboard players set @s sc_burn_warn 0
scoreboard players set @s sc_burn_cd 0
scoreboard players set @s sc_charging 0
scoreboard players set @s sc_charge_dur 0
effect clear @s
attribute @s minecraft:knockback_resistance base set 0.0
attribute @s minecraft:max_health base set 20.0
execute in minecraft:overworld run function sc:inv/restore
gamemode adventure @s
effect give @s minecraft:instant_health 1 10 true
effect give @s minecraft:saturation 2 4 true
function sc:lobby/ensure_present
