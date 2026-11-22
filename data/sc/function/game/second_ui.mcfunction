# 更新顶部 Bossbar 进度与比分文本
execute if score #cfg_dur sc_var matches 0 run return run function sc:game/endless_ui
scoreboard players operation #bb_pct sc_var = #rem_sec sc_var
scoreboard players operation #bb_pct sc_var *= #100 sc_const
scoreboard players operation #bb_pct sc_var /= #cfg_dur sc_var
execute store result bossbar sc:match value run scoreboard players get #bb_pct sc_var

bossbar set sc:match color green
execute if score #rem_sec sc_var matches 11..30 run bossbar set sc:match color purple
execute if score #rem_sec sc_var matches ..10 run bossbar set sc:match color red

bossbar set sc:match name [{text:"剩余 ",color:"white"},{score:{name:"#rem_sec",objective:"sc_var"},color:"yellow",bold:true},{text:" 秒   |   领地（红 : 蓝） ",color:"gray"},{score:{name:"#r_tiles",objective:"sc_var"},color:"red"},{text:" : ",color:"gray"},{score:{name:"#b_tiles",objective:"sc_var"},color:"blue"}]
