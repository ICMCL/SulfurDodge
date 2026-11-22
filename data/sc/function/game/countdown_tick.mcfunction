# 开局 3 秒 (60 tick) 锁定出生位倒计时
execute as @a[tag=sc_alive,scores={sc_team=1}] run tp @s -10.5 65.0 0.5 -90 0
execute as @a[tag=sc_alive,scores={sc_team=2}] run tp @s 11.5 65.0 0.5 90 0

execute if score #phase_tmr sc_var matches 60 run title @a[tag=sc_ingame] times 0 25 5
execute if score #phase_tmr sc_var matches 60 run title @a[tag=sc_ingame] title {text:"3",color:"yellow",bold:true}
execute if score #phase_tmr sc_var matches 60 run title @a[tag=sc_ingame] subtitle {text:"准备抢球刷地！",color:"gray"}
execute if score #phase_tmr sc_var matches 60 run playsound minecraft:block.note_block.hat master @a[tag=sc_ingame] ~ ~ ~ 1.0 1.0

execute if score #phase_tmr sc_var matches 40 run title @a[tag=sc_ingame] title {text:"2",color:"gold",bold:true}
execute if score #phase_tmr sc_var matches 40 run playsound minecraft:block.note_block.hat master @a[tag=sc_ingame] ~ ~ ~ 1.0 1.25

execute if score #phase_tmr sc_var matches 20 run title @a[tag=sc_ingame] title {text:"1",color:"red",bold:true}
execute if score #phase_tmr sc_var matches 20 run playsound minecraft:block.note_block.hat master @a[tag=sc_ingame] ~ ~ ~ 1.0 1.5

scoreboard players remove #phase_tmr sc_var 1
execute if score #phase_tmr sc_var matches ..0 run function sc:game/begin_fight
