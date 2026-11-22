# 四壁缩墙前 2 秒预警粒子与机械蓄力音效
execute if score #collapse_stage sc_var matches 0 run particle minecraft:cloud -13.0 66.5 0.5 0.6 1.2 9.5 0.02 35 force
execute if score #collapse_stage sc_var matches 0 run particle minecraft:cloud 14.0 66.5 0.5 0.6 1.2 9.5 0.02 35 force
execute if score #collapse_stage sc_var matches 0 run particle minecraft:cloud 0.5 66.5 -9.5 13.0 1.2 0.3 0.02 35 force
execute if score #collapse_stage sc_var matches 0 run particle minecraft:cloud 0.5 66.5 10.5 13.0 1.2 0.3 0.02 35 force

execute if score #collapse_stage sc_var matches 1 run particle minecraft:cloud -11.0 66.5 0.5 0.6 1.2 8.5 0.02 30 force
execute if score #collapse_stage sc_var matches 1 run particle minecraft:cloud 12.0 66.5 0.5 0.6 1.2 8.5 0.02 30 force

execute if score #collapse_stage sc_var matches 2..5 run particle minecraft:cloud 0.5 66.5 0.5 8.5 1.2 6.0 0.03 36 force
playsound minecraft:block.piston.contract master @a 0 66 0 1.2 0.75
