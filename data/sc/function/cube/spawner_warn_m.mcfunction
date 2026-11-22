# 在当前最新内推后的南北侧墙中线发球口播放预警光效
$execute if score #need_balls sc_var matches 2.. run particle minecraft:end_rod 0.5 65.5 $(wn) 0.25 0.25 0.15 0.03 4 force
$execute if score #need_balls sc_var matches 2.. run particle minecraft:end_rod 0.5 65.5 $(ws) 0.25 0.25 0.15 0.03 4 force
$execute if score #need_balls sc_var matches 1 if score #launch_side sc_var matches 0 run particle minecraft:end_rod 0.5 65.5 $(wn) 0.25 0.25 0.15 0.03 4 force
$execute if score #need_balls sc_var matches 1 if score #launch_side sc_var matches 1 run particle minecraft:end_rod 0.5 65.5 $(ws) 0.25 0.25 0.15 0.03 4 force
