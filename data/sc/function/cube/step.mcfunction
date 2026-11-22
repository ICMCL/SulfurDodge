# ===== 单个硫方怪每刻物理、刷地、引信与防卡角更新 =====
execute if score @s sc_swap_cd matches 1.. run scoreboard players remove @s sc_swap_cd 1
execute if score @s sc_bumper_cd matches 1.. run scoreboard players remove @s sc_bumper_cd 1

# 防掉出下层竞技场边界兜底 (y=65..70)
execute if entity @s[y=-64,dy=126] run tp @s 0.5 65.2 0.5
execute if entity @s[y=71,dy=20] run tp @s 0.5 65.2 0.5
execute if entity @s[tag=sc_impact] if function sc:cube/impact_sweep run return 0
execute if entity @s[tag=sc_impact] run particle minecraft:electric_spark ~ ~0.45 ~ 0.12 0.1 0.12 0.02 4 force

# 1. 已染色硫方怪 (sc_team=1 红 / 2 蓝) 沿途插值连续刷地；白色中立态 (sc_team=0) 绝不改变地板颜色！
execute if score @s sc_team matches 1..2 run function sc:cube/paint

# 2. 更新位置缓存与当前水平速度缓存（供下一刻插值刷地与重炮破墙动量恢复使用）
execute store result score @s sc_px run data get entity @s Pos[0] 1000
execute store result score @s sc_pz run data get entity @s Pos[2] 1000
execute store result score @s sc_vx run data get entity @s Motion[0] 1000
execute store result score @s sc_vz run data get entity @s Motion[2] 1000

# 3. 阵营尾迹粒子特效
execute if score @s sc_team matches 1 run particle minecraft:dust{color:[1.0,0.2,0.2],scale:1.35} ~ ~0.45 ~ 0.18 0.18 0.18 0 2 force
execute if score @s sc_team matches 2 run particle minecraft:dust{color:[0.2,0.55,1.0],scale:1.35} ~ ~0.45 ~ 0.18 0.18 0.18 0 2 force
execute if score @s sc_heavy matches 1 run particle minecraft:crit ~ ~0.5 ~ 0.2 0.2 0.2 0.05 2 force

# 4. 已点燃硫方怪：防贴墙角停滞脱困 (连续 10 tick 水平速度过低则向场心轻推)
scoreboard players operation #avx sc_var = @s sc_vx
execute if score #avx sc_var matches ..-1 run scoreboard players operation #avx sc_var *= #-1 sc_const
scoreboard players operation #avz sc_var = @s sc_vz
execute if score #avz sc_var matches ..-1 run scoreboard players operation #avz sc_var *= #-1 sc_const
scoreboard players operation #spd_m sc_var = #avx sc_var
scoreboard players operation #spd_m sc_var += #avz sc_var

execute if score @s sc_fuse matches 1.. if score #spd_m sc_var matches ..85 run scoreboard players add @s sc_stuck 1
execute if score #spd_m sc_var matches 86.. run scoreboard players set @s sc_stuck 0
execute if score @s sc_stuck matches 10.. run function sc:cube/unstuck

# 5. 5.0 秒 (100 tick) 硬上限引信倒计时 & 最后 0.5 秒 (10 tick) 高频闪白锁定归属色
execute if score @s sc_fuse matches 1.. run scoreboard players remove @s sc_fuse 1
# 仅用 sc_fuse 结算。也解除风弹或邻近红石意外点燃的原版 TNT 引信。
execute unless data entity @s {fuse:-1} run data modify entity @s fuse set value -1

execute if score @s sc_fuse matches 1..10 run tag @s add sc_locked
execute if score @s sc_fuse matches 1..10 if score #g2 sc_var matches 0 run team join sc_neutral @s
execute if score @s sc_fuse matches 1..10 if score #g2 sc_var matches 1 if score @s sc_team matches 1 run team join red @s
execute if score @s sc_fuse matches 1..10 if score #g2 sc_var matches 1 if score @s sc_team matches 2 run team join blue @s
execute if score @s sc_fuse matches 1..10 if score #g2 sc_var matches 0 run playsound minecraft:block.note_block.hat master @a ~ ~0.5 ~ 0.9 2.0
execute if score @s sc_fuse matches 1..10 run particle minecraft:smoke ~ ~0.85 ~ 0.15 0.15 0.15 0.04 3 force
execute if score @s sc_fuse matches 1.. run function sc:cube/update_fuse_ui

# 6. 引信归零：触发数据包受控爆破泼墨！
execute if score @s sc_fuse matches 0 run function sc:cube/explode
