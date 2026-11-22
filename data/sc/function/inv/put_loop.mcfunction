data modify storage sc:tmp it set from storage sc:tmp list[0]
data remove storage sc:tmp list[0]
execute store result storage sc:tmp sl.s int 1 run data get storage sc:tmp it.Slot
data modify storage sc:tmp it.Slot set value 0b
data modify block 0 58 0 Items set value []
data modify block 0 58 0 Items append from storage sc:tmp it
function sc:inv/put_slot with storage sc:tmp sl
execute if data storage sc:tmp list[0] run function sc:inv/put_loop
