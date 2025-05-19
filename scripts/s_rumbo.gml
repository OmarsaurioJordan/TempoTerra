///s_rumbo(id_nodo, x, y);
// ret: direction

var mx = round(argument1 / m_celda);
var my = round(argument2 / m_celda);
var dir = ds_grid_get(argument0, mx, my);
if dir == -1 {
    return random(360);
}
return dir;

