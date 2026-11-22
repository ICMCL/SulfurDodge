# 右键持续架矛触发回调（每刻触发一次，按住右键即刻进入迎击反染架势）
advancement revoke @s only sc:using_spear
execute unless entity @s[tag=sc_alive] run return 0
execute unless items entity @s weapon.mainhand minecraft:diamond_spear[minecraft:custom_data~{sc_spear:1b}] run return 0
scoreboard players set @s sc_charging 2
scoreboard players add @s sc_charge_dur 1
execute if score @s sc_charge_dur matches 1 run playsound minecraft:item.armor.equip_iron master @s ~ ~ ~ 0.65 1.5
execute if score #state sc_var matches 2 at @s run function sc:player/charge_check
