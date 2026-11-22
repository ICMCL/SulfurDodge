# 补球倒计时：最后 20 tick (1.0 秒) 在侧墙中线发射口播放光效与充能音预警
scoreboard players remove #spawn_cd sc_var 1

scoreboard players operation #need_balls sc_var = #cfg_balls sc_var
scoreboard players operation #need_balls sc_var -= #ball_cnt sc_var

# 预警音效
execute if score #spawn_cd sc_var matches 20 run playsound minecraft:block.note_block.pling master @a 0 66 0 0.9 1.2
execute if score #spawn_cd sc_var matches 10 run playsound minecraft:block.note_block.pling master @a 0 66 0 0.9 1.6

# 南北侧墙中线平齐发球口预警粒子（自动跟随缩墙后的新南北内壁坐标）
execute if score #spawn_cd sc_var matches 1..20 run function sc:cube/spawner_warn_m with storage sc:tmp lz

# 倒计时归零：发射入场！
execute if score #spawn_cd sc_var matches ..0 run function sc:cube/launch_dispatch
