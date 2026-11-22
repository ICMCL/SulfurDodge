# 刷新大厅悬浮规则看板（需在 overworld 执行）
data modify storage sc:cfg txt.dur set value "90 秒"
execute if score #o_dur sc_var matches 0 run data modify storage sc:cfg txt.dur set value "60 秒"
execute if score #o_dur sc_var matches 2 run data modify storage sc:cfg txt.dur set value "120 秒"
execute if score #o_dur sc_var matches 3 run data modify storage sc:cfg txt.dur set value "无尽（只看全歼）"

data modify storage sc:cfg txt.balls set value "2 只"
execute if score #o_balls sc_var matches 0 run data modify storage sc:cfg txt.balls set value "1 只"
execute if score #o_balls sc_var matches 2 run data modify storage sc:cfg txt.balls set value "3 只"

data modify storage sc:cfg txt.blast set value "敌伤友免"
execute if score #o_blast sc_var matches 1 run data modify storage sc:cfg txt.blast set value "纯击飞泼墨"

data modify storage sc:cfg txt.layout set value "固定石墙 + 紫水晶柱"
execute if score #o_layout sc_var matches 1 run data modify storage sc:cfg txt.layout set value "仅固定石墙"
execute if score #o_layout sc_var matches 2 run data modify storage sc:cfg txt.layout set value "无障碍平场"

data modify storage sc:cfg txt.grace set value "0.25 秒"
execute if score #grace_ticks sc_var matches 10 run data modify storage sc:cfg txt.grace set value "0.50 秒"
execute if score #grace_ticks sc_var matches 15 run data modify storage sc:cfg txt.grace set value "0.75 秒"
execute if score #grace_ticks sc_var matches 20 run data modify storage sc:cfg txt.grace set value "1.00 秒"

execute as @e[type=text_display,tag=sc_cfg_board] run data modify entity @s text set value [{text:"💣 硫方涂境 (Sulfur Dodge) 💣\n",color:"gold",bold:true},{text:"站上 ",color:"white",bold:false},{text:"红区",color:"red"},{text:" / ",color:"white"},{text:"蓝区",color:"blue"},{text:" 选队，",color:"white"},{text:"灰区",color:"gray"},{text:" 旁观\n",color:"white"},{text:"时长: ",color:"gray"},{nbt:"txt.dur",storage:"sc:cfg",color:"yellow"},{text:" | 球数: ",color:"gray"},{nbt:"txt.balls",storage:"sc:cfg",color:"aqua"},{text:" | 球速: ",color:"gray"},{score:{name:"#speed_pct",objective:"sc_var"},color:"aqua"},{text:"%",color:"aqua"},{text:"\n爆破: ",color:"gray"},{nbt:"txt.blast",storage:"sc:cfg",color:"gold"},{text:" | 场地: ",color:"gray"},{nbt:"txt.layout",storage:"sc:cfg",color:"light_purple"},{text:"\n踩地安全: ",color:"gray"},{nbt:"txt.grace",storage:"sc:cfg",color:"yellow"},{text:" | 反色门槛: ",color:"gray"},{score:{name:"#parry_mps",objective:"sc_var"},color:"aqua"},{text:" 格/秒",color:"aqua"}]
