# ===== 结束对局、移除硫方怪、全员恢复背包返回二层全景大厅（保留当前战场涂色与破损现场供俯视复盘，直到下一局开始才重置） =====
scoreboard players set #state sc_var 0
scoreboard players set #solo_mode sc_var 0

execute in minecraft:overworld as @e[type=sulfur_cube] run data remove entity @s equipment
execute in minecraft:overworld run tp @e[type=sulfur_cube] 0 -200 0
execute in minecraft:overworld run kill @e[type=sulfur_cube]
execute in minecraft:overworld run kill @e[type=wind_charge]
execute in minecraft:overworld run kill @e[type=marker,tag=sc_wpad]
execute in minecraft:overworld run kill @e[tag=sc_wpad_ui]

bossbar set sc:match visible false
bossbar set sc:match players
scoreboard objectives setdisplay sidebar

execute as @a[tag=sc_ingame] run function sc:player/cleanup_to_lobby
