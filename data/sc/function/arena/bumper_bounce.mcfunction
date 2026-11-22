# 赋予斜向 35° 旋转偏转 + 高速弹射加成 (1.08 格/tick)
scoreboard players set @s sc_bumper_cd 8
execute store result score #cx sc_var run data get entity @s Pos[0] 1000
execute store result score #cz sc_var run data get entity @s Pos[2] 1000

scoreboard players operation #rx sc_var = #cx sc_var
scoreboard players operation #rx sc_var -= #bx sc_var
scoreboard players operation #rz sc_var = #cz sc_var
scoreboard players operation #rz sc_var -= #bz sc_var

# 叠加切向旋量制造稳定斜角反射弹道，突破原版正交墙反射局限
scoreboard players operation #tx sc_var = #rz sc_var
scoreboard players operation #tx sc_var *= #-1 sc_const
scoreboard players operation #tx sc_var *= #3 sc_const
scoreboard players operation #tx sc_var /= #5 sc_const

scoreboard players operation #tz sc_var = #rx sc_var
scoreboard players operation #tz sc_var *= #3 sc_const
scoreboard players operation #tz sc_var /= #5 sc_const

execute if score #g2 sc_var matches 1 run scoreboard players operation #tx sc_var *= #-1 sc_const
execute if score #g2 sc_var matches 1 run scoreboard players operation #tz sc_var *= #-1 sc_const

scoreboard players operation #in_x sc_var = #rx sc_var
scoreboard players operation #in_x sc_var += #tx sc_var
scoreboard players operation #in_z sc_var = #rz sc_var
scoreboard players operation #in_z sc_var += #tz sc_var
scoreboard players set #target_spd sc_var 1080
function sc:util/norm2d

function sc:cube/set_horizontal
data modify entity @s Motion[1] set value 0.06d

particle minecraft:electric_spark ~ ~0.5 ~ 0.35 0.35 0.35 0.25 22 force
playsound minecraft:block.amethyst_block.chime master @a ~ ~0.5 ~ 1.4 1.35
playsound minecraft:block.amethyst_cluster.hit master @a ~ ~0.5 ~ 1.0 1.2
