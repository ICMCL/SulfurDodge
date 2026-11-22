# 伤害冷却按实时时间走；安全时间只累计接触敌色的 tick，离地不清零。
execute if score @s sc_burn_cd matches 1.. run scoreboard players remove @s sc_burn_cd 1
tag @s remove sc_on_hazard
tag @s remove sc_on_safe

# 仅在着地时采样脚底与碰撞箱四角地板类型
execute if predicate sc:on_ground if score @s sc_team matches 1 run function sc:player/check_floor_red
execute if predicate sc:on_ground if score @s sc_team matches 2 run function sc:player/check_floor_blue

# 双脚完全回到己方色或中立灰才重置安全时间。
execute if entity @s[tag=sc_on_safe,tag=!sc_on_hazard] run scoreboard players set @s sc_burn_warn 0

execute unless entity @s[tag=sc_on_hazard] run return 0
particle minecraft:lava ~ ~0.1 ~ 0.25 0.05 0.25 0.02 2 force
execute if score @s sc_burn_warn matches 0 run playsound minecraft:block.lava.extinguish master @s ~ ~ ~ 0.45 1.7
execute if score @s sc_burn_warn < #grace_ticks sc_var run scoreboard players add @s sc_burn_warn 1
execute if score @s sc_burn_warn < #grace_ticks sc_var run return 0
execute if score @s sc_burn_cd matches 1.. run return 0
scoreboard players set @s sc_burn_cd 9
particle minecraft:flame ~ ~0.3 ~ 0.3 0.2 0.3 0.06 12 force
damage @s 3 sc:floor_burn
