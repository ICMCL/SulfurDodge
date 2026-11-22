$data modify storage sc:game result set value {text:"$(result)",color:"$(color)",bold:true}
title @a[tag=sc_ingame] times 5 70 15
execute if score #cfg_dur sc_var matches 0 run title @a[tag=sc_ingame] subtitle {text:"无尽淘汰 · 一人一命",color:"gray"}
execute if score #cfg_dur sc_var matches 1.. run title @a[tag=sc_ingame] subtitle [{text:"本场领地  ",color:"gray"},{score:{name:"#r_tiles",objective:"sc_var"},color:"red"},{text:" : ",color:"gray"},{score:{name:"#b_tiles",objective:"sc_var"},color:"blue"}]
title @a[tag=sc_ingame] title {nbt:"result",storage:"sc:game",interpret:true}
execute if score #cfg_dur sc_var matches 0 run tellraw @a [{text:"[无尽淘汰] ",color:"gold"},{nbt:"result",storage:"sc:game",interpret:true}]
execute if score #cfg_dur sc_var matches 1.. run tellraw @a [{text:"[硫方涂境] ",color:"gold"},{nbt:"result",storage:"sc:game",interpret:true},{text:"　领地（红 : 蓝） ",color:"gray"},{score:{name:"#r_tiles",objective:"sc_var"},color:"red"},{text:" : ",color:"gray"},{score:{name:"#b_tiles",objective:"sc_var"},color:"blue"}]
playsound minecraft:ui.toast.challenge_complete master @a ~ ~ ~ 0.9 1.0
function sc:game/stop
