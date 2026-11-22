# ===== 1 号位左键轻刺 (Jab) 命中硫方怪处理 =====

# -1 才是未点燃；白色不等于未点燃（白球可能已有连锁引信）。
execute if score @s sc_fuse matches 0 run return 0
scoreboard players set #jb_mode sc_var 2
execute if score @s sc_fuse matches -1 run scoreboard players set #jb_mode sc_var 0
execute if score @s sc_fuse matches 1.. if score @s sc_team = #hitter_team sc_var run scoreboard players set #jb_mode sc_var 1

# 未点燃：染成己方颜色，点燃 5 秒引信。
execute if score #jb_mode sc_var matches 0 run scoreboard players operation @s sc_team = #hitter_team sc_var
execute if score #jb_mode sc_var matches 0 if score @s sc_team matches 1 run team join red @s
execute if score #jb_mode sc_var matches 0 if score @s sc_team matches 2 run team join blue @s
execute if score #jb_mode sc_var matches 0 run scoreboard players set @s sc_fuse 100
execute if score #jb_mode sc_var matches 0 run scoreboard players set @s sc_width 1
execute if score #jb_mode sc_var matches 0 run scoreboard players set @s sc_heavy 0
execute if score #jb_mode sc_var matches 0 run scoreboard players set @s sc_swap_cd 5
execute if score #jb_mode sc_var matches 0 run playsound minecraft:entity.tnt.primed master @a ~ ~0.5 ~ 1.0 1.15
execute if score #jb_mode sc_var matches 0 run playsound minecraft:entity.sulfur_cube.explosive.hit master @a ~ ~0.5 ~ 1.1 1.1
execute if score #jb_mode sc_var matches 0 run scoreboard players set #spd sc_var 820

# 情况 B：命中己方已染色球 -> 同队接力变向提速 + 延迟 1.0 秒爆炸（上限 5.0 秒）
execute if score #jb_mode sc_var matches 1 run function sc:cube/extend_own_fuse
execute if score #jb_mode sc_var matches 1 run playsound minecraft:entity.sulfur_cube.explosive.hit master @a ~ ~0.5 ~ 1.1 1.35
execute if score #jb_mode sc_var matches 1 run particle minecraft:crit ~ ~0.5 ~ 0.25 0.25 0.25 0.15 10 force
execute if score #jb_mode sc_var matches 1 run title @a[tag=sc_hitter,limit=1] actionbar {text:"⏱ 同队接力！爆炸延迟 +1.0s（上限 5.0s）",color:"green",bold:true}
execute if score #jb_mode sc_var matches 1 run scoreboard players set #spd sc_var 900

# 非己方已点燃球（包括白球）：左键只能拨开。
execute if score #jb_mode sc_var matches 2 run playsound minecraft:item.shield.block master @a ~ ~0.5 ~ 0.95 1.4
execute if score #jb_mode sc_var matches 2 run particle minecraft:poof ~ ~0.5 ~ 0.25 0.25 0.25 0.08 10 force
execute if score #jb_mode sc_var matches 2 run title @a[tag=sc_hitter,limit=1] actionbar {text:"已拨开来球，颜色和倒计时不变",color:"yellow"}
execute if score #jb_mode sc_var matches 2 run scoreboard players set #spd sc_var 800

function sc:cube/shoot_forward
data modify entity @s Motion[1] set value 0.06d

# 染色态击球点立即落墨一格增强打击反馈，并即时刷新头顶倒计时名称牌
execute if score @s sc_team matches 1..2 run function sc:cube/paint
execute if score @s sc_fuse matches 1.. run function sc:cube/update_fuse_ui
