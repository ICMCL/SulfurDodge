# 固定石砖走原版方块反弹；只有玩家放置的泥墙参与受撞判定。
execute as @e[type=marker,tag=sc_wpad] at @s run function sc:arena/wpad_step
execute as @e[type=marker,tag=sc_pwall] at @s run function sc:arena/pwall_step
