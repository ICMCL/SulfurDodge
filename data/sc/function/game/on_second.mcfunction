# 限时比赛的倒计时、领地统计和缩墙。
scoreboard players operation #rem_sec sc_var = #rem_ticks sc_var
scoreboard players operation #rem_sec sc_var /= #20 sc_const
scoreboard players operation rem_sec sc_side = #rem_sec sc_var

function sc:arena/count_tiles
function sc:game/second_ui

# 最后 30 秒四面高弹外墙逐圈内推预警与执行
execute if score #rem_sec sc_var matches 32 run tellraw @a[tag=sc_ingame] [{text:"[硫方涂境] ",color:"gold",bold:true},{text:"⚠ 警告：2 秒后四面外墙将开始逐圈向内推进缩圈！反弹密度即将翻倍！",color:"yellow",bold:false}]
execute if score #rem_sec sc_var matches 32 run function sc:arena/collapse_warn
execute if score #rem_sec sc_var matches 27 run function sc:arena/collapse_warn
execute if score #rem_sec sc_var matches 22 run function sc:arena/collapse_warn
execute if score #rem_sec sc_var matches 17 run function sc:arena/collapse_warn
execute if score #rem_sec sc_var matches 12 run function sc:arena/collapse_warn
execute if score #rem_sec sc_var matches 7 run function sc:arena/collapse_warn

execute if score #rem_sec sc_var matches 30 run function sc:arena/collapse_step
execute if score #rem_sec sc_var matches 25 run function sc:arena/collapse_step
execute if score #rem_sec sc_var matches 20 run function sc:arena/collapse_step
execute if score #rem_sec sc_var matches 15 run function sc:arena/collapse_step
execute if score #rem_sec sc_var matches 10 run function sc:arena/collapse_step
execute if score #rem_sec sc_var matches 5 run function sc:arena/collapse_step

# 最后 5 秒读秒音效
execute if score #rem_sec sc_var matches 1..5 run playsound minecraft:block.note_block.pling master @a[tag=sc_ingame] ~ ~ ~ 0.9 1.8
