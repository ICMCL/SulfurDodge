# ===== 1 号位右键架矛冲撞 (Charge) 相对闭合速度校验 =====
# 连锁白球与敌色球走同一套反色判定；新球没有有效引信。
execute unless score #hitter_team sc_var matches 1..2 run return 0
execute unless score @s sc_team matches 0..2 run return 0
execute if score @s sc_team = #hitter_team sc_var run return 0
execute unless score @s sc_fuse matches 11.. run return 0
execute if entity @s[tag=sc_locked] run return 0
execute unless score @s sc_swap_cd matches 0 run return 0
execute store result score #bvx sc_var run data get entity @s Motion[0] 1000
execute store result score #bvz sc_var run data get entity @s Motion[2] 1000

# 1) 基于当前 Motion 的视线相对闭合速度 #cls
scoreboard players operation #rvx sc_var = #pvx sc_var
scoreboard players operation #rvx sc_var -= #bvx sc_var
scoreboard players operation #rvz sc_var = #pvz sc_var
scoreboard players operation #rvz sc_var -= #bvz sc_var

scoreboard players operation #cls sc_var = #rvx sc_var
scoreboard players operation #cls sc_var *= #fx sc_var
scoreboard players operation #ctmp sc_var = #rvz sc_var
scoreboard players operation #ctmp sc_var *= #fz sc_var
scoreboard players operation #cls sc_var += #ctmp sc_var
scoreboard players operation #cls sc_var /= #1000 sc_const

# 两者单位均为千分格/tick。只算朝向对方的水平分量。
execute if score #cls sc_var >= #parry_min sc_var run function sc:cube/on_charge_hit
