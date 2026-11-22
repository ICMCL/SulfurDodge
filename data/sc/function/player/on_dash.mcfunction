execute unless score #state sc_var matches 2 run return 0
execute unless entity @s[tag=sc_alive,scores={sc_team=1..2}] run return 0
scoreboard players set @s sc_thrust 4
execute at @s run function sc:player/dash_scan
