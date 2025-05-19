///s_colision(id, empuja_moviles);
// el id que llama ya hara su comprobacion si cae en agua

with argument0 {
    // con solidos
    var otr = instance_place(x, y, g_parent[mytime, m_par_bloque]);
    if otr != noone {
        direction = point_direction(otr.x, otr.y, x, y);
        var vv = dlt * m_unit_velocidad;
        x += lengthdir_x(vv, direction);
        y += lengthdir_y(vv, direction);
    }
    // con moviles
    else {
        otr = instance_place(x, y, g_parent[mytime, m_par_movil]);
        if otr != noone {
            direction = point_direction(otr.x, otr.y, x, y);
            var vv = dlt * m_unit_velocidad;
            if argument1 {
                vv /= 2;
                // empujarlo
                var ax = otr.x;
                var ay = otr.y;
                otr.x += lengthdir_x(vv, -direction);
                otr.y += lengthdir_y(vv, -direction);
                if s_enagua(otr.x, otr.y) {
                    otr.x = ax;
                    otr.y = ay;
                }
            }
            x += lengthdir_x(vv, direction);
            y += lengthdir_y(vv, direction);
        }
    }
}

