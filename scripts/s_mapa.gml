///s_mapa();
// ret: ds_grid bool con zonas de tierra y agua

var w = ceil(room_width / m_celda);
var h = ceil(room_height / m_celda);
var res = ds_grid_create(w, h);
// ver si existen los datos
ini_open("mapa.ini");
if ini_key_exists("mapa", "ds_grid") {
    ds_grid_read(res, ini_read_string("mapa", "ds_grid", ""));
    ini_close();
    return res;
}
ini_close();
// crear los datos a partir de sprite
ds_grid_clear(res, false);
var sss = surface_create(w, h);
surface_set_target(sss);
draw_sprite_ext(d_mapa, 0, 0, 0,
    w / sprite_get_width(d_mapa),
    h / sprite_get_height(d_mapa),
    0, c_white, 1);
var p, n, b;
for (var v = 0; v < w; v++) {
    for (var g = 0; g < h; g++) {
        p = surface_getpixel_ext(sss, v, g);
        n = point_distance_3d(0, 0, 0, // negro
            p & 255, (p >> 8) & 255, (p >> 16) & 255);
        b = point_distance_3d(255, 255, 255, // blanco
            p & 255, (p >> 8) & 255, (p >> 16) & 255);
        if n < b {
            ds_grid_set(res, v, g, true);
        }
    }
}
surface_reset_target();
surface_free(sss);
// guardar en archivo
ini_open("mapa.ini");
ini_write_string("mapa", "ds_grid", ds_grid_write(res));
ini_close();
return res;

