# 同一次原版命中先以攻击者准备球速方向，再以实际受击实体执行 jab_contact。
execute unless score #state sc_var matches 2 run return 0
execute unless entity @s[type=player,tag=sc_alive,scores={sc_team=1..2}] run return 0
execute unless items entity @s weapon.mainhand minecraft:diamond_spear[minecraft:custom_data~{sc_spear:1b}] run return 0
function sc:player/shot_context
