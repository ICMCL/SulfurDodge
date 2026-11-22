# ===== 硫方怪发球器与场上所有硫方怪每刻主循环（主世界执行） =====
# 1. 场上硫方怪个体更新（缓存动量、硬引信倒计时、沿途刷地、卡角脱困、引爆）
execute as @e[type=sulfur_cube,tag=sc_ball] at @s run function sc:cube/step

# 2. 统计当前在场硫方怪数量并驱动南北中线对称预警补球
scoreboard players set #ball_cnt sc_var 0
execute as @e[type=sulfur_cube,tag=sc_ball] run scoreboard players add #ball_cnt sc_var 1

execute if score #ball_cnt sc_var >= #cfg_balls sc_var run scoreboard players set #spawn_cd sc_var 40
execute if score #ball_cnt sc_var < #cfg_balls sc_var run function sc:cube/spawner_step
