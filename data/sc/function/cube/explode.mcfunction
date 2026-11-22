# ===== 受控伪爆炸结算：3.5 格圆域泼墨 + 炸毁短墙 + 多球连锁弹飞引爆 + 模式 A/B 玩家爆破 =====
tag @s add sc_exploding
execute if entity @s[tag=sc_impact] run tp @s ~ ~ ~
scoreboard players operation #exp_team sc_var = @s sc_team
execute store result score #ex_x sc_var run data get entity @s Pos[0] 1000
execute store result score #ex_z sc_var run data get entity @s Pos[2] 1000

# 1. 爆炸粒子与震撼音效
particle minecraft:explosion_emitter ~ ~0.5 ~ 0 0 0 0 1 force
execute if score #exp_team sc_var matches 0 run particle minecraft:dust{color:[1.0,1.0,1.0],scale:2.4} ~ ~0.6 ~ 1.8 0.5 1.8 0.1 80 force
execute if score #exp_team sc_var matches 1 run particle minecraft:dust{color:[1.0,0.15,0.15],scale:2.4} ~ ~0.6 ~ 1.8 0.5 1.8 0.1 80 force
execute if score #exp_team sc_var matches 2 run particle minecraft:dust{color:[0.15,0.45,1.0],scale:2.4} ~ ~0.6 ~ 1.8 0.5 1.8 0.1 80 force
playsound minecraft:entity.generic.explode master @a ~ ~0.5 ~ 1.6 0.85

execute if score #exp_team sc_var matches 0 run function sc:cube/splash {floor:"light_gray_concrete"}
execute if score #exp_team sc_var matches 1 run function sc:cube/splash {floor:"red_concrete"}
execute if score #exp_team sc_var matches 2 run function sc:cube/splash {floor:"blue_concrete"}

# 只炸玩家放的泥墙。固定石砖、加速柱和场馆边界不参与破坏。
execute as @e[type=marker,tag=sc_pwall,distance=..4.2] at @s run function sc:arena/pwall_break

# 4. 多球连锁传爆：冲击波弹飞半径内其他硫方怪，若为未点燃中立球则激活 1.5s 短引信中立爆破
execute as @e[type=sulfur_cube,tag=sc_ball,tag=!sc_exploding,distance=..5.0] at @s run function sc:cube/chain_other

# 5. 对玩家爆炸效果：
#   - 白色中立硫方怪 (#exp_team=0)：无差别炸伤全场所有人（红蓝通杀）！
#   - 阵营染色硫方怪 (#exp_team=1/2)：模式 A (#o_blast=0) 敌伤友免；模式 B (#o_blast=1) 纯击飞0伤
execute if score #exp_team sc_var matches 0 as @a[tag=sc_alive,distance=..1.8] run damage @s 9 sc:sulfur_blast
execute if score #exp_team sc_var matches 0 as @a[tag=sc_alive,distance=1.8..3.0] run damage @s 6 sc:sulfur_blast
execute if score #exp_team sc_var matches 0 as @a[tag=sc_alive,distance=3.0..4.2] run damage @s 3 sc:sulfur_blast

execute if score #o_blast sc_var matches 0 if score #exp_team sc_var matches 1 as @a[tag=sc_alive,scores={sc_team=2},distance=..1.8] run damage @s 9 sc:sulfur_blast
execute if score #o_blast sc_var matches 0 if score #exp_team sc_var matches 1 as @a[tag=sc_alive,scores={sc_team=2},distance=1.8..3.0] run damage @s 6 sc:sulfur_blast
execute if score #o_blast sc_var matches 0 if score #exp_team sc_var matches 1 as @a[tag=sc_alive,scores={sc_team=2},distance=3.0..4.2] run damage @s 3 sc:sulfur_blast

execute if score #o_blast sc_var matches 0 if score #exp_team sc_var matches 2 as @a[tag=sc_alive,scores={sc_team=1},distance=..1.8] run damage @s 9 sc:sulfur_blast
execute if score #o_blast sc_var matches 0 if score #exp_team sc_var matches 2 as @a[tag=sc_alive,scores={sc_team=1},distance=1.8..3.0] run damage @s 6 sc:sulfur_blast
execute if score #o_blast sc_var matches 0 if score #exp_team sc_var matches 2 as @a[tag=sc_alive,scores={sc_team=1},distance=3.0..4.2] run damage @s 3 sc:sulfur_blast

# 无伤风弹冲击波：无视玩家近战击退抗性，将爆炸点附近玩家向外震飞且不破坏任何方块
summon wind_charge ~ ~0.3 ~ {Motion:[0.0d,-1.5d,0.0d]}

# 刷新实时地板格数统计
function sc:arena/count_tiles

# 6. 安全无分裂移除该硫方怪（卸除体内 TNT 后传虚空清理）
data remove entity @s equipment
tp @s 0 -200 0
kill @s
return 1
