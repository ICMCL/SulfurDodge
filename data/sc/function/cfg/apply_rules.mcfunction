scoreboard players operation #n sc_var = @s sc_set
scoreboard players set @s sc_set 0
execute if score #state sc_var matches 1..2 run return run tellraw @s {text:"[硫方涂境] 比赛进行中无法修改规则设置！",color:"red"}
execute unless score #n sc_var matches 10000000..13212233 run return run tellraw @s {text:"设置未保存，请重新打开讲台菜单。",color:"red"}

# 从低位到高位解码；整组校验通过后才改动当前设置。
scoreboard players set #bad_rule sc_var 0
function sc:cfg/read_digit {key:"parry",max:3}
function sc:cfg/read_digit {key:"grace",max:3}
function sc:cfg/read_digit {key:"speed",max:2}
function sc:cfg/read_digit {key:"layout",max:2}
function sc:cfg/read_digit {key:"blast",max:1}
function sc:cfg/read_digit {key:"balls",max:2}
function sc:cfg/read_digit {key:"dur",max:3}
execute if score #bad_rule sc_var matches 1 run return run tellraw @s {text:"设置选项无效，未保存。请重新打开讲台菜单。",color:"red"}
scoreboard players operation #o_dur sc_var = #new_dur sc_var
scoreboard players operation #o_balls sc_var = #new_balls sc_var
scoreboard players operation #o_blast sc_var = #new_blast sc_var
scoreboard players operation #o_layout sc_var = #new_layout sc_var
scoreboard players operation #o_speed sc_var = #new_speed sc_var
scoreboard players operation #o_grace sc_var = #new_grace sc_var
scoreboard players operation #o_parry sc_var = #new_parry sc_var

function sc:cfg/calc
execute in minecraft:overworld run function sc:cfg/lobby_board
playsound minecraft:block.note_block.pling master @s ~ ~ ~ 0.8 1.5
tellraw @a [{text:"[硫方涂境] ",color:"gold"},{selector:"@s"},{text:" 更新了比赛规则设置。",color:"yellow"}]
