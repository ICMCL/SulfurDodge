# 静止的球没有可旋转的方向，只给一个朝向引力点的小起速。
scoreboard players set #target_spd sc_var 100
function sc:util/norm2d
scoreboard players operation @s sc_vx = #out_x sc_var
scoreboard players operation @s sc_vz = #out_z sc_var
function sc:cube/restore_vel
execute if entity @s[tag=sc_impact] run function sc:cube/impact_sweep
