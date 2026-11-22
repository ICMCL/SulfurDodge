scoreboard players operation #c sc_var = @s sc_cfg
scoreboard players set @s sc_cfg 0
execute unless score #c sc_var matches 1..3 run return run tellraw @s {text:"无效的菜单选项，请重新打开讲台。",color:"yellow"}
execute if score #state sc_var matches 1..2 unless score #c sc_var matches 2 run return run tellraw @s {text:"[硫方涂境] 比赛进行中无法修改规则设置！",color:"red"}
execute if score #c sc_var matches 1 run function sc:cfg/show_rules
execute if score #c sc_var matches 2 run dialog show @s sc:help
execute if score #c sc_var matches 3 run function sc:cfg/defaults
execute if score #c sc_var matches 3 in minecraft:overworld run function sc:cfg/lobby_board
execute if score #c sc_var matches 3 run tellraw @a [{text:"[硫方涂境] ",color:"gold"},{selector:"@s"},{text:" 已将比赛规则恢复为默认设置。",color:"yellow"}]
