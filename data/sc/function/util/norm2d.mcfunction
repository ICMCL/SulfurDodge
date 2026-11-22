# 二维向量归一化缩放工具：输入 #in_x, #in_z 与目标模长 #target_spd，输出 #out_x, #out_z
scoreboard players operation #ax sc_var = #in_x sc_var
execute if score #ax sc_var matches ..-1 run scoreboard players operation #ax sc_var *= #-1 sc_const
scoreboard players operation #az sc_var = #in_z sc_var
execute if score #az sc_var matches ..-1 run scoreboard players operation #az sc_var *= #-1 sc_const

# Alpha-max + beta-min 近似欧氏模长: len = max + min * 2 / 5
scoreboard players operation #maxv sc_var = #ax sc_var
scoreboard players operation #minv sc_var = #az sc_var
execute if score #az sc_var > #ax sc_var run scoreboard players operation #maxv sc_var = #az sc_var
execute if score #az sc_var > #ax sc_var run scoreboard players operation #minv sc_var = #ax sc_var

scoreboard players operation #minv sc_var *= #2 sc_const
scoreboard players operation #minv sc_var /= #5 sc_const
scoreboard players operation #len sc_var = #maxv sc_var
scoreboard players operation #len sc_var += #minv sc_var
execute if score #len sc_var matches ..0 run scoreboard players set #len sc_var 1

scoreboard players operation #out_x sc_var = #in_x sc_var
scoreboard players operation #out_x sc_var *= #target_spd sc_var
scoreboard players operation #out_x sc_var /= #len sc_var

scoreboard players operation #out_z sc_var = #in_z sc_var
scoreboard players operation #out_z sc_var *= #target_spd sc_var
scoreboard players operation #out_z sc_var /= #len sc_var
