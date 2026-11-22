execute if block ~ ~-0.35 ~ #sc:safe_blue run tag @s add sc_on_safe
execute if block ~ ~-0.35 ~ #sc:hazard_blue run tag @s add sc_on_hazard
execute unless entity @s[tag=sc_on_hazard] if block ~0.28 ~-0.35 ~0.28 #sc:hazard_blue run tag @s add sc_on_hazard
execute unless entity @s[tag=sc_on_hazard] if block ~-0.28 ~-0.35 ~0.28 #sc:hazard_blue run tag @s add sc_on_hazard
execute unless entity @s[tag=sc_on_hazard] if block ~0.28 ~-0.35 ~-0.28 #sc:hazard_blue run tag @s add sc_on_hazard
execute unless entity @s[tag=sc_on_hazard] if block ~-0.28 ~-0.35 ~-0.28 #sc:hazard_blue run tag @s add sc_on_hazard
