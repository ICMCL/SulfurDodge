# ===== 新生成的白色中立含 TNT 硫方怪初始化 =====
tag @s remove sc_new
team join sc_neutral @s
scoreboard players set @s sc_team 0
scoreboard players set @s sc_fuse -1
scoreboard players set @s sc_width 1
scoreboard players set @s sc_heavy 0
scoreboard players set @s sc_swap_cd 0
scoreboard players set @s sc_bumper_cd 0
scoreboard players set @s sc_stuck 0
data modify entity @s CustomNameVisible set value 0b

execute store result score @s sc_px run data get entity @s Pos[0] 1000
execute store result score @s sc_pz run data get entity @s Pos[2] 1000
execute store result score #out_x sc_var run data get entity @s Motion[0] 1000
execute store result score #out_z sc_var run data get entity @s Motion[2] 1000
function sc:cube/set_horizontal

particle minecraft:poof ~ ~0.5 ~ 0.25 0.25 0.25 0.05 12 force
