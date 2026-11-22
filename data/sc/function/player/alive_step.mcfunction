# 1. 记录 2-tick 平滑水平速度向量 (0.001 格/tick)，供右键架矛相对闭合速度计算
execute store result score #nx sc_var run data get entity @s Pos[0] 1000
execute store result score #nz sc_var run data get entity @s Pos[2] 1000
scoreboard players operation #dx sc_var = #nx sc_var
scoreboard players operation #dx sc_var -= @s sc_px
scoreboard players operation #dz sc_var = #nz sc_var
scoreboard players operation #dz sc_var -= @s sc_pz

scoreboard players operation @s sc_vx += #dx sc_var
scoreboard players operation @s sc_vx /= #2 sc_const
scoreboard players operation @s sc_vz += #dz sc_var
scoreboard players operation @s sc_vz /= #2 sc_const

scoreboard players operation @s sc_px = #nx sc_var
scoreboard players operation @s sc_pz = #nz sc_var

# 防意外卡出场外兜底（限制在下层竞技场 y=65..70）
execute if entity @s[y=-64,dy=126] run tp @s 0.5 65.2 0.5
execute if entity @s[y=71,dy=20] run tp @s 0.5 65.2 0.5

# 2. 自动补齐误丢的双槽长矛
function sc:player/refill_spears
execute if score @s sc_thrust matches 1.. run function sc:player/dash_scan

# 命中判定只在 using_item 回调执行；松手后的 HUD 宽限不算第二次出手。
execute if score @s sc_charging matches 1.. run scoreboard players remove @s sc_charging 1
execute unless score @s sc_charging matches 1.. run scoreboard players set @s sc_charge_dur 0

# 4. 冲刺体力条 (饥饿值) 自动恢复（每 2.5 秒 +1 点，锁零饱和度）
execute if score #state sc_var matches 2 run function sc:player/stamina_tick

# 5. 敌色地板灼烧
execute if score #state sc_var matches 2 run function sc:player/floor_burn_tick

# 6. 第一人称来球方向警示与脚下状态 HUD（每 2 tick 刷新）
execute if score #state sc_var matches 2 if score #g2 sc_var matches 0 run function sc:player/hud_tick
