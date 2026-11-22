$execute store result storage sc:dlgtmp o.i int 1 run scoreboard players get $(s) sc_var
$data modify storage sc:dlgtmp o.n set value $(n)
function sc:cfg/setopt2 with storage sc:dlgtmp o
