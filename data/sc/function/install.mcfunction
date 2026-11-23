# ===== 手动重同步世界规则、北侧樱阁大厅实体与内场动态区（绑定 .mca 存档平时自动完成） =====
execute in minecraft:overworld run function sc:internal/world_boot
execute as @a[tag=!sc_ingame] run function sc:lobby/arrive
execute as @a[tag=!sc_ingame,gamemode=!creative] run gamemode adventure @s
playsound minecraft:ui.toast.challenge_complete master @a ~ ~ ~ 0.8 1.2
tellraw @a [{text:"[硫方涂境] ",color:"gold",bold:true},{text:"樱庭云阶浮岛规则与大厅看板已同步！走进红/蓝樱亭选队，右键讲台调整设置。",color:"green",bold:false}]
