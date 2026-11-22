tag @s remove sc_wpad_ready
scoreboard players set @s sc_fuse 400
execute as @e[type=item_display,tag=sc_wpad_vis,distance=..1.0,limit=1] run data modify entity @s transformation.scale set value [0.0f,0.0f,0.0f]
execute as @e[type=text_display,tag=sc_wpad_txt,distance=..1.5,limit=1] run data modify entity @s text set value {text:"补给已领取，20 秒后刷新",color:"gray"}
