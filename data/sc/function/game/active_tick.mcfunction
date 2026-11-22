# ===== 激战阶段每刻更新 =====
function sc:arena/walls_tick
execute if score #o_layout sc_var matches 0 run function sc:arena/bumpers_tick
function sc:cube/tick
function sc:player/tick

# 已全歼结算时，不再推进时钟或触发超时判定。
execute unless score #state sc_var matches 2 run return 0

# 无尽模式保留球、机关与玩家的逐刻更新，不推进时钟或触发限时事件。
execute if score #cfg_dur sc_var matches 0 if score #g20 sc_var matches 0 run function sc:game/endless_ui
execute if score #cfg_dur sc_var matches 0 run return 0
scoreboard players remove #rem_ticks sc_var 1
scoreboard players operation #rt20 sc_var = #rem_ticks sc_var
scoreboard players operation #rt20 sc_var %= #20 sc_const

execute if score #rt20 sc_var matches 0 run function sc:game/on_second
execute if score #rem_ticks sc_var matches ..0 if score #state sc_var matches 2 run function sc:game/timeout_judge
