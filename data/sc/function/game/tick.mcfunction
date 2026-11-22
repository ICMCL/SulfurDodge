# 1=开局倒计时，2=激战。
execute if score #state sc_var matches 1 run function sc:game/countdown_tick
execute if score #state sc_var matches 2 run function sc:game/active_tick
