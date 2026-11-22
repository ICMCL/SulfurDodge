# ===== 硫方涂境 · 全局主循环 =====
scoreboard players add #gt sc_var 1
scoreboard players operation #g20 sc_var = #gt sc_var
scoreboard players operation #g20 sc_var %= #20 sc_const
scoreboard players operation #g2 sc_var = #gt sc_var
scoreboard players operation #g2 sc_var %= #2 sc_const

# 重连与新玩家欢迎
execute as @a[scores={sc_left=1..}] run function sc:lobby/rejoin
execute as @a[tag=!sc_seen] run function sc:lobby/welcome

# 对话框触发器（非对局玩家可修改设置）
scoreboard players enable @a[tag=!sc_ingame] sc_cfg
scoreboard players enable @a[tag=!sc_ingame] sc_set
execute as @a[scores={sc_cfg=1..}] run function sc:cfg/open
execute as @a[scores={sc_set=1..}] run function sc:cfg/apply_rules

# 防止丢弃比赛装备与清理分裂小硫方怪
execute as @e[type=item] run function sc:util/item
execute in minecraft:overworld run kill @e[type=sulfur_cube,tag=!sc_ball]

# 大厅循环
execute in minecraft:overworld run function sc:lobby/tick

# 竞技场状态机循环
execute if score #state sc_var matches 1..2 in minecraft:overworld run function sc:game/tick
