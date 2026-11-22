advancement revoke @s only sc:using_gold
execute unless score #state sc_var matches 2 run return 0
execute unless entity @s[tag=sc_alive] run return 0
execute unless items entity @s weapon.mainhand minecraft:golden_spear[minecraft:custom_data~{sc_kit:1b}] run return 0

# 只由实际持用回调施力。两次回调不连续就重新架矛；不消耗体力。
scoreboard players operation #g_prev sc_var = #gt sc_var
scoreboard players remove #g_prev sc_var 1
execute unless score @s sc_g_last = #g_prev sc_var run scoreboard players set @s sc_g_hold 0
scoreboard players operation @s sc_g_last = #gt sc_var
execute unless score @s sc_g_hold matches 6 run scoreboard players add @s sc_g_hold 1
execute if score @s sc_g_hold matches 1 at @s run playsound minecraft:block.amethyst_block.chime master @a[distance=..18] ~ ~ ~ 0.6 0.8
execute if score @s sc_g_hold matches ..5 run return 0
execute at @s positioned ~ ~0.49 ~ rotated ~ 0 run function sc:gravity/field
