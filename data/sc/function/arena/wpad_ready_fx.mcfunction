tag @s add sc_wpad_ready
execute as @e[type=item_display,tag=sc_wpad_vis,distance=..1.0,limit=1] run data modify entity @s transformation.scale set value [0.55f,0.55f,0.55f]
execute as @e[type=text_display,tag=sc_wpad_txt,distance=..1.5,limit=1] run data modify entity @s text set value [{text:"泥砖反弹墙 ×1\n",color:"gold",bold:true},{text:"踩上拾取",color:"yellow",bold:false}]
particle minecraft:end_rod ~ ~0.6 ~ 0.25 0.3 0.25 0.04 12 force
playsound minecraft:block.beacon.power_select master @a ~ ~0.5 ~ 0.65 1.6
