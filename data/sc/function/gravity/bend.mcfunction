execute store result score #gx sc_var run data get entity @s Pos[0] 1000
execute store result score #gz sc_var run data get entity @s Pos[2] 1000
scoreboard players operation #in_x sc_var = #g_x sc_var
scoreboard players operation #in_x sc_var -= #gx sc_var
scoreboard players operation #in_z sc_var = #g_z sc_var
scoreboard players operation #in_z sc_var -= #gz sc_var
execute if score #in_x sc_var matches -150..150 if score #in_z sc_var matches -150..150 run return 0
execute store result score #ux sc_var run data get entity @s Motion[0] 1000
execute store result score #uz sc_var run data get entity @s Motion[2] 1000
execute if score #ux sc_var matches -39..39 if score #uz sc_var matches -39..39 run return run function sc:gravity/nudge

# 叉积决定转向；已经对准（约 5.7° 内）就不改动。旋转速度向量，而不是不断叠加速度。
scoreboard players operation #cross sc_var = #ux sc_var
scoreboard players operation #cross sc_var *= #in_z sc_var
scoreboard players operation #t sc_var = #uz sc_var
scoreboard players operation #t sc_var *= #in_x sc_var
scoreboard players operation #cross sc_var -= #t sc_var
scoreboard players operation #dot sc_var = #ux sc_var
scoreboard players operation #dot sc_var *= #in_x sc_var
scoreboard players operation #t sc_var = #uz sc_var
scoreboard players operation #t sc_var *= #in_z sc_var
scoreboard players operation #dot sc_var += #t sc_var
scoreboard players set #sin6 sc_var 1045
execute if score #cross sc_var matches ..-1 run scoreboard players set #sin6 sc_var -1045
execute if score #cross sc_var matches ..-1 run scoreboard players operation #cross sc_var *= #-1 sc_const
scoreboard players operation #cross sc_var *= #10 sc_const
execute if score #cross sc_var <= #dot sc_var run return 0

scoreboard players operation @s sc_vx = #ux sc_var
scoreboard players operation @s sc_vx *= #cos6 sc_const
scoreboard players operation #t sc_var = #uz sc_var
scoreboard players operation #t sc_var *= #sin6 sc_var
scoreboard players operation @s sc_vx -= #t sc_var
scoreboard players operation @s sc_vx /= #10000 sc_const
scoreboard players operation @s sc_vz = #uz sc_var
scoreboard players operation @s sc_vz *= #cos6 sc_const
scoreboard players operation #t sc_var = #ux sc_var
scoreboard players operation #t sc_var *= #sin6 sc_var
scoreboard players operation @s sc_vz += #t sc_var
scoreboard players operation @s sc_vz /= #10000 sc_const
function sc:cube/restore_vel
execute if entity @s[tag=sc_impact] run function sc:cube/impact_sweep
