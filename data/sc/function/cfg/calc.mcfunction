# 根据选项索引计算实际生效数值
scoreboard players set #cfg_dur sc_var 90
execute if score #o_dur sc_var matches 0 run scoreboard players set #cfg_dur sc_var 60
execute if score #o_dur sc_var matches 2 run scoreboard players set #cfg_dur sc_var 120
execute if score #o_dur sc_var matches 3 run scoreboard players set #cfg_dur sc_var 0

scoreboard players set #cfg_balls sc_var 2
execute if score #o_balls sc_var matches 0 run scoreboard players set #cfg_balls sc_var 1
execute if score #o_balls sc_var matches 2 run scoreboard players set #cfg_balls sc_var 3

scoreboard players set #speed_pct sc_var 70
execute if score #o_speed sc_var matches 0 run scoreboard players set #speed_pct sc_var 50
execute if score #o_speed sc_var matches 2 run scoreboard players set #speed_pct sc_var 100

scoreboard players operation #grace_ticks sc_var = #o_grace sc_var
scoreboard players add #grace_ticks sc_var 1
scoreboard players operation #grace_ticks sc_var *= #5 sc_const

scoreboard players operation #parry_mps sc_var = #o_parry sc_var
scoreboard players operation #parry_mps sc_var *= #2 sc_const
scoreboard players add #parry_mps sc_var 4
# 闭合速度的计分单位是千分格/tick：1 格/秒 = 50 千分格/tick。
scoreboard players operation #parry_min sc_var = #parry_mps sc_var
scoreboard players operation #parry_min sc_var *= #50 sc_const
