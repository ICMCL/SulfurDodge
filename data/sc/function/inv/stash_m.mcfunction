$data remove storage sc:inv p.p$(id)
$data modify storage sc:inv p.p$(id).inv set from entity @s Inventory
$data modify storage sc:inv p.p$(id).eq set from entity @s equipment
