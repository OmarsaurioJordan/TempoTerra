///s_suelo(ind_subimg);
// arg0: indice sub imagen de mundo para tiles

var w = ceil(room_width / m_celda);
var h = ceil(room_height / m_celda);
var res = ds_grid_create(w, h);
var sss = surface_create(w, h);
surface_set_target(sss);
draw_sprite_ext(d_mapa, argument0 + 1, 0, 0,
    w / sprite_get_width(d_mapa),
    h / sprite_get_height(d_mapa),
    0, c_white, 1);
var p;
var lis = ds_priority_create();
var col, sel;
col[0, 0] = 0; col[0, 1] = 0; col[0, 2] = 0; // negro
col[1, 0] = 255; col[1, 1] = 255; col[1, 2] = 255; // blanco
col[2, 0] = 255; col[2, 1] = 0; col[2, 2] = 0; // rojo
col[3, 0] = 0; col[3, 1] = 255; col[3, 2] = 0; // verde
col[4, 0] = 0; col[4, 1] = 0; col[4, 2] = 255; // azul
ini_open("mapa.ini");
var chrg = ini_key_exists("mapa", "tile" + string(argument0));
if chrg {
    chrg = false;
    
    
    
    
    ds_grid_read(res, ini_read_string("mapa", "tile" + string(argument0), ""));
}
for (var v = 0; v < w; v++) {
    for (var g = 0; g < h; g++) {
        // cargar datos del tile desde archivo
        if chrg {
            sel = ds_grid_get(res, v, g);
        }
        // cargar datos del tile a partir de sprite
        else {
            p = surface_getpixel_ext(sss, v, g);
            ds_priority_clear(lis);
            for (var c = 0; c < 5; c++) {
                ds_priority_add(lis, c, point_distance_3d(
                    col[c, 0], col[c, 1], col[c, 2],
                    p & 255, (p >> 8) & 255, (p >> 16) & 255));
            }
            sel = ds_priority_find_min(lis);
            ds_grid_set(res, v, g, sel);
        }
        // crear como tal un tile
        switch sel {
            case 0: // otros materiales
                if argument0 == 4 { // pavimento
                    tile_add(dd_suelo, (9 + irandom(2)) * 136, 0, 136, 136,
                        (v - 0.5) * m_celda, (g - 0.5) * m_celda,
                        900 + argument0 * 10 + irandom(9));
                }
                else if argument0 == 3 or argument0 == 0 { // tierra
                    tile_add(dd_suelo_ext, irandom(2) * 136, 0, 136, 136,
                        (v - 0.5) * m_celda, (g - 0.5) * m_celda,
                        900 + argument0 * 10 + irandom(9));
                }
                else { // futurista
                    tile_add(dd_suelo, (12 + irandom(2)) * 136, 0, 136, 136,
                        (v - 0.5) * m_celda, (g - 0.5) * m_celda,
                        900 + argument0 * 10 + irandom(9));
                }
                break;
            case 2: // rojo desierto
                tile_add(dd_suelo, irandom(2) * 136, 0, 136, 136,
                    (v - 0.5) * m_celda, (g - 0.5) * m_celda,
                    900 + argument0 * 10 + irandom(9));
                break;
            case 3: // verde selva
                tile_add(dd_suelo, (3 + irandom(2)) * 136, 0, 136, 136,
                    (v - 0.5) * m_celda, (g - 0.5) * m_celda,
                    900 + argument0 * 10 + irandom(9));
                break;
            case 4: // azul nevado
                tile_add(dd_suelo, (6 + irandom(2)) * 136, 0, 136, 136,
                    (v - 0.5) * m_celda, (g - 0.5) * m_celda,
                    900 + argument0 * 10 + irandom(9));
                break;
        }
    }
}
if !chrg {
    ini_write_string("mapa", "tile" + string(argument0), ds_grid_write(res));
}
ini_close();
ds_priority_destroy(lis);
surface_reset_target();
surface_free(sss);
ds_grid_destroy(res);

