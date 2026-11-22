# 固定刷墙补给点每刻逻辑
execute if score @s sc_fuse matches 1.. run scoreboard players remove @s sc_fuse 1

# 冷却结束瞬间：显现悬浮泥砖模型与拾取提示
execute if score @s sc_fuse matches 0 unless entity @s[tag=sc_wpad_ready] run function sc:arena/wpad_ready_fx

# 就绪态呼吸光效与玩家踩点拾取检测
execute if entity @s[tag=sc_wpad_ready] if score #g20 sc_var matches 0 run particle minecraft:happy_villager ~ ~0.45 ~ 0.28 0.2 0.28 0.02 3 force
execute if entity @s[tag=sc_wpad_ready] if entity @a[tag=sc_alive,distance=..1.15] run function sc:arena/wpad_try_pickup
