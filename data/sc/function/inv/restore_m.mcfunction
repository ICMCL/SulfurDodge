$data modify storage sc:tmp list set from storage sc:inv p.p$(id).inv
$data modify storage sc:tmp eq set from storage sc:inv p.p$(id).eq
$data remove storage sc:inv p.p$(id)
