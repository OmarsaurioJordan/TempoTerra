///s_enagua(x, y);
// ret: true si en el agua

var w = floor(argument0 / m_celda);
var h = floor(argument1 / m_celda);
return !ds_grid_get(ds_mapa, w, h);

