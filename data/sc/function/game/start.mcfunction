# ===== 正式开始一场比赛（主世界执行，开赛瞬间才重置下方战场） =====
execute if score #state sc_var matches 1..2 run return 0
function sc:cfg/calc

scoreboard players add #gid sc_var 1
scoreboard players set #solo_mode sc_var 0

# 关闭自然生命恢复（饥饿条纯作 Lunge 冲刺体力条）
gamerule natural_health_regeneration false

function sc:arena/reset_round
execute as @a[team=red] run function sc:player/enter_match
execute as @a[team=blue] run function sc:player/enter_match
scoreboard players operation #rem_sec sc_var = #cfg_dur sc_var
scoreboard players operation rem_sec sc_side = #rem_sec sc_var
scoreboard players operation #rem_ticks sc_var = #cfg_dur sc_var
scoreboard players operation #rem_ticks sc_var *= #20 sc_const

execute if score #cfg_dur sc_var matches 1.. run scoreboard objectives setdisplay sidebar sc_side
execute if score #cfg_dur sc_var matches 0 run scoreboard objectives setdisplay sidebar
bossbar set sc:match max 100
bossbar set sc:match value 100
bossbar set sc:match color yellow
bossbar set sc:match name {text:"准备开战",color:"gold"}
bossbar set sc:match players @a
bossbar set sc:match visible true
scoreboard players set #phase_tmr sc_var 60
scoreboard players set #state sc_var 1
