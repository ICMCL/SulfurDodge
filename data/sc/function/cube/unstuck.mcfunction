# 卡角低速脱困：朝竞技场中心 (0.5, 65.0, 0.5) 赋予 0.42 格/tick 脱困推力
scoreboard players set @s sc_stuck 0
execute store result score #cx sc_var run data get entity @s Pos[0] 1000
execute store result score #cz sc_var run data get entity @s Pos[2] 1000
scoreboard players set #in_x sc_var 500
scoreboard players operation #in_x sc_var -= #cx sc_var
scoreboard players set #in_z sc_var 500
scoreboard players operation #in_z sc_var -= #cz sc_var
# 若恰在正中心则赋予斜向微推
execute if score #in_x sc_var matches -50..50 if score #in_z sc_var matches -50..50 run scoreboard players set #in_x sc_var 350
execute if score #in_x sc_var matches -50..50 if score #in_z sc_var matches -50..50 run scoreboard players set #in_z sc_var -350

scoreboard players set #target_spd sc_var 420
function sc:util/norm2d
function sc:cube/set_horizontal
data modify entity @s Motion[1] set value 0.08d
playsound minecraft:entity.sulfur_cube.bounce master @a ~ ~0.5 ~ 0.7 1.3
