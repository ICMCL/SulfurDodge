# 计算最近敌方硫方怪相对于玩家视线的象限方向 (1=前, 2=后, 3=左, 4=右)
execute unless entity @n[type=marker,tag=sc_math] run summon marker 0 64 0 {Tags:["sc_math"]}
execute at @s rotated ~ 0 positioned ^ ^ ^1 run tp @n[type=marker,tag=sc_math] ~ ~ ~
execute store result score #fx sc_var run data get entity @n[type=marker,tag=sc_math] Pos[0] 1000
execute store result score #fz sc_var run data get entity @n[type=marker,tag=sc_math] Pos[2] 1000
execute store result score #ox sc_var run data get entity @s Pos[0] 1000
execute store result score #oz sc_var run data get entity @s Pos[2] 1000
scoreboard players operation #fx sc_var -= #ox sc_var
scoreboard players operation #fz sc_var -= #oz sc_var

execute store result score #bx sc_var run data get entity @n[type=sulfur_cube,tag=sc_hud_b] Pos[0] 1000
execute store result score #bz sc_var run data get entity @n[type=sulfur_cube,tag=sc_hud_b] Pos[2] 1000
scoreboard players operation #bx sc_var -= #ox sc_var
scoreboard players operation #bz sc_var -= #oz sc_var

# 前向投影 dot_f = (bx * fx + bz * fz) / 1000
scoreboard players operation #df sc_var = #bx sc_var
scoreboard players operation #df sc_var *= #fx sc_var
scoreboard players operation #t1 sc_var = #bz sc_var
scoreboard players operation #t1 sc_var *= #fz sc_var
scoreboard players operation #df sc_var += #t1 sc_var
scoreboard players operation #df sc_var /= #1000 sc_const

# 右向投影 dot_r = (-bx * fz + bz * fx) / 1000
scoreboard players operation #dr sc_var = #bx sc_var
scoreboard players operation #dr sc_var *= #fz sc_var
scoreboard players operation #dr sc_var *= #-1 sc_const
scoreboard players operation #t2 sc_var = #bz sc_var
scoreboard players operation #t2 sc_var *= #fx sc_var
scoreboard players operation #dr sc_var += #t2 sc_var
scoreboard players operation #dr sc_var /= #1000 sc_const

scoreboard players operation #adf sc_var = #df sc_var
execute if score #adf sc_var matches ..-1 run scoreboard players operation #adf sc_var *= #-1 sc_const
scoreboard players operation #adr sc_var = #dr sc_var
execute if score #adr sc_var matches ..-1 run scoreboard players operation #adr sc_var *= #-1 sc_const

execute if score #adf sc_var >= #adr sc_var if score #df sc_var matches 0.. run scoreboard players set @s sc_hud_dir 1
execute if score #adf sc_var >= #adr sc_var if score #df sc_var matches ..-1 run scoreboard players set @s sc_hud_dir 2
execute if score #adr sc_var > #adf sc_var if score #dr sc_var matches ..-1 run scoreboard players set @s sc_hud_dir 3
execute if score #adr sc_var > #adf sc_var if score #dr sc_var matches 0.. run scoreboard players set @s sc_hud_dir 4

# 背后 6 格内逼近额外播放高频提醒音
execute if score @s sc_hud_dir matches 2 if entity @e[type=sulfur_cube,tag=sc_hud_b,distance=..6] run playsound minecraft:block.note_block.didgeridoo master @s ~ ~ ~ 0.6 1.8
