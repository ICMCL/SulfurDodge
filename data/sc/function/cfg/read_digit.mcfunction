$scoreboard players operation #new_$(key) sc_var = #n sc_var
$scoreboard players operation #new_$(key) sc_var %= #10 sc_const
$execute unless score #new_$(key) sc_var matches 0..$(max) run scoreboard players set #bad_rule sc_var 1
scoreboard players operation #n sc_var /= #10 sc_const
