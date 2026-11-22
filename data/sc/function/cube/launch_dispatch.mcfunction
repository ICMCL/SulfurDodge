scoreboard players set #spawn_cd sc_var 40
playsound minecraft:entity.breeze.shoot master @a 0 66 0 1.1 1.25

# 等概率抽取 -50..-15 或 +15..+50 度，一次发球共用一个抽样。
execute store result score #serve_yaw sc_var run random value -36..35 sc:serve
execute if score #serve_yaw sc_var matches ..-1 run scoreboard players remove #serve_yaw sc_var 14
execute if score #serve_yaw sc_var matches 0.. run scoreboard players add #serve_yaw sc_var 15
execute store result storage sc:tmp lz.yaw int 1 run scoreboard players get #serve_yaw sc_var
execute if score #need_balls sc_var matches 2.. run function sc:cube/launch_north with storage sc:tmp lz
execute if score #need_balls sc_var matches 2.. run return run function sc:cube/launch_south with storage sc:tmp lz

# 单球补充：南北交替轮换发射
execute if score #launch_side sc_var matches 0 run function sc:cube/launch_north with storage sc:tmp lz
execute if score #launch_side sc_var matches 1 run function sc:cube/launch_south with storage sc:tmp lz
scoreboard players add #launch_side sc_var 1
scoreboard players operation #launch_side sc_var %= #2 sc_const
