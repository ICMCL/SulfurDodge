tag @s remove sc_wpad_init
# 从激战开始计时，倒计时阶段不消耗补给时间。
scoreboard players set @s sc_fuse 160
summon item_display ~ ~0.55 ~ {Tags:["sc_wpad_ui","sc_wpad_vis"],billboard:"fixed",item:{id:"minecraft:mud_bricks",count:1},transformation:{translation:[0.0f,0.0f,0.0f],left_rotation:[0.0f,0.3827f,0.0f,0.9239f],scale:[0.0f,0.0f,0.0f],right_rotation:[0.0f,0.0f,0.0f,1.0f]}}
summon text_display ~ ~1.25 ~ {Tags:["sc_wpad_ui","sc_wpad_txt"],billboard:"center",background:1073741824,text:{text:"⏳ 反弹墙准备中...",color:"gray"}}
