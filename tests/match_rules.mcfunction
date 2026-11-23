# Run in an isolated vanilla GameTest world, after the chunks around the arena load.
scoreboard players set #errors sc_var 0
scoreboard players set #hitter_team sc_var 1
scoreboard players set #fx sc_var 1000
scoreboard players set #fz sc_var 0
scoreboard players set #pvx sc_var 0
scoreboard players set #pvz sc_var 0
summon minecraft:sulfur_cube 0.5 65 0.5 {Size:1,Tags:["sc_ball","sc_test_ball"],equipment:{body:{id:"minecraft:tnt",count:1}},Motion:[-0.8d,0d,0d]}
execute as @e[tag=sc_test_ball] at @s run function sc:cube/init
execute as @e[tag=sc_test_ball] at @s run function sc:cube/try_charge_hit
execute unless entity @e[tag=sc_test_ball,scores={sc_team=0,sc_fuse=-1,sc_width=1}] run scoreboard players add #errors sc_var 1
execute as @e[tag=sc_test_ball] at @s run function sc:cube/on_jab_hit
execute unless entity @e[tag=sc_test_ball,scores={sc_team=1,sc_fuse=100,sc_vx=574}] run scoreboard players add #errors sc_var 1
scoreboard players set @e[tag=sc_test_ball] sc_fuse 50
scoreboard players set @e[tag=sc_test_ball] sc_swap_cd 0
scoreboard players set #pvx sc_var 299
execute as @e[tag=sc_test_ball] run data modify entity @s Motion set value [0d,0d,0d]
execute as @e[tag=sc_test_ball] at @s run function sc:cube/try_charge_hit
execute unless entity @e[tag=sc_test_ball,scores={sc_team=1,sc_fuse=50,sc_width=1}] run scoreboard players add #errors sc_var 1
scoreboard players set #hitter_team sc_var 2
execute as @e[tag=sc_test_ball] at @s run function sc:cube/try_charge_hit
execute unless entity @e[tag=sc_test_ball,scores={sc_team=1,sc_fuse=50,sc_width=1}] run scoreboard players add #errors sc_var 1
scoreboard players set #pvx sc_var 300
execute as @e[tag=sc_test_ball] at @s run function sc:cube/try_charge_hit
execute unless entity @e[tag=sc_test_ball,scores={sc_team=2,sc_fuse=50,sc_width=3,sc_heavy=1,sc_swap_cd=6,sc_vx=875}] run scoreboard players add #errors sc_var 1
scoreboard players set #hitter_team sc_var 1
scoreboard players set #pvx sc_var 0
scoreboard players set @e[tag=sc_test_ball] sc_swap_cd 0
scoreboard players set @e[tag=sc_test_ball] sc_fuse 10
execute as @e[tag=sc_test_ball] run data modify entity @s Motion set value [-0.8d,0d,0d]
execute as @e[tag=sc_test_ball] at @s run function sc:cube/try_charge_hit
execute unless entity @e[tag=sc_test_ball,scores={sc_team=2,sc_fuse=10,sc_swap_cd=0}] run scoreboard players add #errors sc_var 1

# Test the offset collision probe next to the west wall; test both regular and heavy hits.
summon marker -13.5 65 0.5 {Tags:["sc_pwall","sc_test_wall"]}
fill -14 65 0 -14 66 0 mud_bricks
fill -14 67 0 -14 68 0 barrier
scoreboard players set @e[tag=sc_test_wall] sc_id 2
scoreboard players set @e[tag=sc_test_wall] sc_swap_cd 0
tp @e[tag=sc_test_ball] -12.51 65 0.5
scoreboard players set @e[tag=sc_test_ball] sc_heavy 0
execute as @e[tag=sc_test_wall] at @s run function sc:arena/pwall_step
execute unless block -14 65 0 packed_mud run scoreboard players add #errors sc_var 1
execute unless block -15 65 -1 tuff_bricks run scoreboard players add #errors sc_var 1
scoreboard players set @e[tag=sc_test_wall] sc_swap_cd 0
execute as @e[tag=sc_test_wall] at @s run function sc:arena/pwall_step
execute unless block -14 65 0 air run scoreboard players add #errors sc_var 1
execute if entity @e[tag=sc_test_wall] run scoreboard players add #errors sc_var 1
summon marker -13.5 65 0.5 {Tags:["sc_pwall","sc_test_wall"]}
fill -14 65 0 -14 66 0 mud_bricks
scoreboard players set @e[tag=sc_test_wall] sc_id 2
scoreboard players set @e[tag=sc_test_ball] sc_heavy 1
execute as @e[tag=sc_test_wall] at @s run function sc:arena/pwall_step
execute if entity @e[tag=sc_test_wall] run scoreboard players add #errors sc_var 1
execute unless block -14 65 0 air run scoreboard players add #errors sc_var 1
execute unless block -15 65 -1 tuff_bricks run scoreboard players add #errors sc_var 1

# The blast must not carve a hole even if a stale marker occupies a shrink wall.
summon marker -11.5 65 0.5 {Tags:["sc_pwall","sc_test_blast"]}
fill -12 65 0 -12 66 0 tuff_bricks
execute as @e[tag=sc_test_ball] at @s run function sc:cube/explode
execute if entity @e[tag=sc_test_blast] run scoreboard players add #errors sc_var 1
execute unless block -12 65 0 tuff_bricks run scoreboard players add #errors sc_var 1
execute unless block -15 65 0 tuff_bricks run scoreboard players add #errors sc_var 1

# Neutral sliding leaves the board alone. A neutral explosion clears only the shared disc.
fill -4 64 -4 -1 64 4 red_concrete
fill 0 64 -4 4 64 4 blue_concrete
setblock 0 64 1 tuff_bricks
summon minecraft:sulfur_cube 0.5 65 0.5 {Size:1,Tags:["sc_ball","sc_wash_test"],equipment:{body:{id:"minecraft:tnt",count:1}}}
execute as @e[tag=sc_wash_test] at @s run function sc:cube/init
execute as @e[tag=sc_wash_test] at @s run function sc:cube/step
execute unless block 0 64 0 blue_concrete run scoreboard players add #errors sc_var 1
function sc:arena/count_tiles
scoreboard players operation #want_red sc_var = #r_tiles sc_var
scoreboard players operation #want_blue sc_var = #b_tiles sc_var
scoreboard players remove #want_red sc_var 15
scoreboard players remove #want_blue sc_var 21
execute as @e[tag=sc_wash_test] at @s run function sc:cube/explode
execute unless score #want_red sc_var = #r_tiles sc_var run scoreboard players add #errors sc_var 1
execute unless score #want_blue sc_var = #b_tiles sc_var run scoreboard players add #errors sc_var 1
execute unless block -3 64 1 light_gray_concrete run scoreboard players add #errors sc_var 1
execute unless block 3 64 1 light_gray_concrete run scoreboard players add #errors sc_var 1
execute unless block 0 64 1 tuff_bricks run scoreboard players add #errors sc_var 1
execute unless block -3 64 2 red_concrete run scoreboard players add #errors sc_var 1
execute unless block 3 64 2 blue_concrete run scoreboard players add #errors sc_var 1

# Check all seven menu positions and round-trip their packed trigger.
data modify storage sc_test:menu a set from storage sc:dlg rules.inputs[0].key
data modify storage sc_test:menu b set from storage sc:dlg rules.inputs[1].key
data modify storage sc_test:menu c set from storage sc:dlg rules.inputs[2].key
data modify storage sc_test:menu d set from storage sc:dlg rules.inputs[3].key
data modify storage sc_test:menu e set from storage sc:dlg rules.inputs[4].key
data modify storage sc_test:menu f set from storage sc:dlg rules.inputs[5].key
data modify storage sc_test:menu g set from storage sc:dlg rules.inputs[6].key
execute unless data storage sc_test:menu {a:"du",b:"ba",c:"bl",d:"la",e:"sp",f:"gr",g:"pa"} run scoreboard players add #errors sc_var 1
execute unless data storage sc:dlg rules.inputs[0].options[{id:"3"}] run scoreboard players add #errors sc_var 1
execute if data storage sc:dlg rules.inputs[7] run scoreboard players add #errors sc_var 1
summon armor_stand 0 65 0 {Tags:["sc_test_host"],NoGravity:1b}
scoreboard players set @e[tag=sc_test_host] sc_set 12012030
execute as @e[tag=sc_test_host] run function sc:cfg/apply_rules
execute unless score #cfg_dur sc_var matches 120 run scoreboard players add #errors sc_var 1
execute unless score #cfg_balls sc_var matches 1 run scoreboard players add #errors sc_var 1
execute unless score #o_blast sc_var matches 1 run scoreboard players add #errors sc_var 1
execute unless score #o_layout sc_var matches 2 run scoreboard players add #errors sc_var 1
execute unless score #grace_ticks sc_var matches 20 run scoreboard players add #errors sc_var 1
execute unless score #parry_min sc_var matches 200 run scoreboard players add #errors sc_var 1
execute unless data storage sc:cfg {txt:{dur:"120 秒",balls:"1 只",blast:"纯击飞泼墨",layout:"无障碍平场",grace:"1.00 秒"}} run scoreboard players add #errors sc_var 1
scoreboard players set #out_x sc_var 820
scoreboard players set #out_z sc_var -820
execute as @e[tag=sc_test_host] run function sc:cube/set_horizontal
execute unless entity @e[tag=sc_test_host,scores={sc_vx=410,sc_vz=-410}] run scoreboard players add #errors sc_var 1
scoreboard players set @e[tag=sc_test_host] sc_set 11100213
execute as @e[tag=sc_test_host] run function sc:cfg/apply_rules
execute unless score #grace_ticks sc_var matches 10 run scoreboard players add #errors sc_var 1
execute unless score #parry_min sc_var matches 500 run scoreboard players add #errors sc_var 1
scoreboard players set @e[tag=sc_test_host] sc_set 11100290
execute as @e[tag=sc_test_host] run function sc:cfg/apply_rules
execute unless score #grace_ticks sc_var matches 10 run scoreboard players add #errors sc_var 1
execute unless score #parry_min sc_var matches 500 run scoreboard players add #errors sc_var 1
execute as @e[tag=sc_test_host] run function sc:cube/set_horizontal
execute unless entity @e[tag=sc_test_host,scores={sc_vx=820,sc_vz=-820}] run scoreboard players add #errors sc_var 1
function sc:cfg/defaults
execute unless score #grace_ticks sc_var matches 5 run scoreboard players add #errors sc_var 1
execute unless score #parry_min sc_var matches 300 run scoreboard players add #errors sc_var 1
execute as @e[tag=sc_test_host] run function sc:cube/set_horizontal
execute unless entity @e[tag=sc_test_host,scores={sc_vx=574,sc_vz=-574}] run scoreboard players add #errors sc_var 1

# Verify bound .mca Sakura Cloud Courtyard static architecture, open-air barrier containment, and Zen paintable floor.
execute unless block 0 69 -17 calcite run scoreboard players add #errors sc_var 1
execute unless block 0 69 -16 emerald_block run scoreboard players add #errors sc_var 1
execute unless block 0 70 -16 stone_button run scoreboard players add #errors sc_var 1
execute unless block 0 70 -15 lectern[facing=north] run scoreboard players add #errors sc_var 1
execute unless block 0 58 0 chest run scoreboard players add #errors sc_var 1
execute unless block -21 63 0 water run scoreboard players add #errors sc_var 1
execute unless block 0 71 0 barrier run scoreboard players add #errors sc_var 1

# Test regular and heavy contact against a fixed wall. The same subsequent blast hits both materials.
function sc:arena/fixed_walls {wall:"polished_tuff",cap:"barrier"}
summon sulfur_cube 8.48 65 5.5 {Size:1,Tags:["sc_ball","sc_test_impact"],equipment:{body:{id:"minecraft:tnt",count:1}}}
execute as @e[tag=sc_test_impact] at @s run function sc:cube/init
function sc:arena/walls_tick
execute unless block 7 65 5 polished_tuff run scoreboard players add #errors sc_var 1
scoreboard players set @e[tag=sc_test_impact] sc_heavy 1
function sc:arena/walls_tick
execute unless block 7 65 5 polished_tuff run scoreboard players add #errors sc_var 1
summon marker 9.5 65 5.5 {Tags:["sc_pwall"]}
fill 9 65 5 9 66 5 mud_bricks
execute as @e[tag=sc_test_impact] at @s run function sc:cube/explode
execute unless block 7 65 5 polished_tuff run scoreboard players add #errors sc_var 1
execute unless block 9 65 5 air run scoreboard players add #errors sc_var 1
scoreboard players set #collapse_stage sc_var 3
function sc:arena/collapse_step
execute unless block 7 65 5 air run scoreboard players add #errors sc_var 1
execute unless block -7 68 -4 air run scoreboard players add #errors sc_var 1

# Each pad has its own timer; leaving a pickup unclaimed must not start another cooldown.
function sc:arena/wpads_init
execute store result score #pad_count sc_var if entity @e[tag=sc_wpad,scores={sc_fuse=160}]
execute unless score #pad_count sc_var matches 2 run scoreboard players add #errors sc_var 1
scoreboard players set @e[tag=sc_wpad] sc_fuse 2
execute as @e[tag=sc_wpad] at @s run function sc:arena/wpad_step
execute if entity @e[tag=sc_wpad_ready] run scoreboard players add #errors sc_var 1
execute as @e[tag=sc_wpad] at @s run function sc:arena/wpad_step
execute as @e[tag=sc_wpad] at @s run function sc:arena/wpad_step
execute store result score #pad_count sc_var if entity @e[tag=sc_wpad_ready,scores={sc_fuse=0}]
execute unless score #pad_count sc_var matches 2 run scoreboard players add #errors sc_var 1
execute positioned 5.5 65 0.5 as @n[tag=sc_wpad] at @s run function sc:arena/wpad_cooldown
execute positioned 5.5 65 0.5 unless entity @e[tag=sc_wpad,tag=!sc_wpad_ready,distance=..0.1,scores={sc_fuse=400}] run scoreboard players add #errors sc_var 1
execute positioned -4.5 65 0.5 unless entity @e[tag=sc_wpad_ready,distance=..0.1] run scoreboard players add #errors sc_var 1

# Every territory result ends the match immediately, including equal non-zero areas.
fill -14 64 -10 14 64 10 light_gray_concrete
setblock 0 64 0 red_concrete
scoreboard players set #state sc_var 2
function sc:game/timeout_judge
execute unless score #state sc_var matches 0 run scoreboard players add #errors sc_var 1
execute unless data storage sc:game {result:{color:"red"}} run scoreboard players add #errors sc_var 1
setblock 1 64 0 blue_concrete
scoreboard players set #state sc_var 2
function sc:game/timeout_judge
execute unless score #state sc_var matches 0 run scoreboard players add #errors sc_var 1
execute unless data storage sc:game {result:{color:"yellow"}} run scoreboard players add #errors sc_var 1
setblock 2 64 0 blue_concrete
scoreboard players set #state sc_var 2
function sc:game/timeout_judge
execute unless score #state sc_var matches 0 run scoreboard players add #errors sc_var 1
execute unless data storage sc:game {result:{color:"blue"}} run scoreboard players add #errors sc_var 1

# Same unequal territory, no survivors: endless must draw, never award blue a timeout win.
scoreboard players set @e[tag=sc_test_host] sc_set 13212233
execute as @e[tag=sc_test_host] run function sc:cfg/apply_rules
execute unless score #cfg_dur sc_var matches 0 run scoreboard players add #errors sc_var 1
execute unless data storage sc:cfg {txt:{dur:"无尽（只看全歼）"}} run scoreboard players add #errors sc_var 1
scoreboard players set #state sc_var 2
function sc:game/timeout_judge
execute unless score #state sc_var matches 2 run scoreboard players add #errors sc_var 1
function sc:game/check_alive
execute unless score #state sc_var matches 0 run scoreboard players add #errors sc_var 1
execute unless data storage sc:game {result:{color:"yellow"}} run scoreboard players add #errors sc_var 1
function sc:cfg/defaults
execute unless score #cfg_dur sc_var matches 90 run scoreboard players add #errors sc_var 1
execute unless block 0 71 0 barrier run scoreboard players add #errors sc_var 1
execute if score #errors sc_var matches 0 run say SC_RULES_OK
execute unless score #errors sc_var matches 0 run say SC_RULES_FAILED
