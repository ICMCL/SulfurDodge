# Size:1 球约一格宽。只检查球身，不把脚下地板当墙。
execute unless block ~-0.49 ~0.02 ~-0.49 air run return run function sc:cube/explode
execute unless block ~-0.49 ~0.02 ~0.49 air run return run function sc:cube/explode
execute unless block ~0.49 ~0.02 ~-0.49 air run return run function sc:cube/explode
execute unless block ~0.49 ~0.02 ~0.49 air run return run function sc:cube/explode
execute unless block ~-0.49 ~0.96 ~-0.49 air run return run function sc:cube/explode
execute unless block ~-0.49 ~0.96 ~0.49 air run return run function sc:cube/explode
execute unless block ~0.49 ~0.96 ~-0.49 air run return run function sc:cube/explode
execute unless block ~0.49 ~0.96 ~0.49 air run return run function sc:cube/explode
execute if score @s sc_team matches 1 positioned ~-0.5 ~ ~-0.5 if entity @a[tag=sc_alive,scores={sc_team=2},dx=0,dy=0,dz=0] positioned ~0.5 ~ ~0.5 run return run function sc:cube/explode
execute if score @s sc_team matches 2 positioned ~-0.5 ~ ~-0.5 if entity @a[tag=sc_alive,scores={sc_team=1},dx=0,dy=0,dz=0] positioned ~0.5 ~ ~0.5 run return run function sc:cube/explode
scoreboard players remove #impact_steps sc_var 1
$execute if score #impact_steps sc_var matches 0.. positioned ~$(x) ~ ~$(z) run return run function sc:cube/impact_probe with storage sc:tmp sweep
return 0
