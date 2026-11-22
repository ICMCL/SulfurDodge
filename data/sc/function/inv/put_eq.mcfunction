$data modify storage sc:tmp it set from storage sc:tmp eq.$(k)
data modify storage sc:tmp it.Slot set value 0b
data modify block 0 58 0 Items set value []
data modify block 0 58 0 Items append from storage sc:tmp it
$item replace entity @s $(s) from block 0 58 0 container.0
