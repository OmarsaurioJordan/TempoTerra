///s_step_player(id);

with argument0 {
    
    // mover camara
    var xx = view_xview[0] + view_wview[0] / 2;
    var yy = view_yview[0] + view_hview[0] / 2 + 100;
    var d = point_direction(x, y, o_mouse.x, o_mouse.y);
    var v = min(point_distance(x, y, o_mouse.x, o_mouse.y) / 2,
        view_hview[0] / 4);
    var xp = x + lengthdir_x(v, d);
    var yp = y + lengthdir_y(v, d);
    var vv = point_distance(xx, yy, xp, yp);
    s_cam_corre(point_direction(xx, yy, xp, yp), min(vv, vv * dlt * 2));
    
    // rebotar con bloques y moviles
    s_colision(id, true);
    
    // manejo con teclas
    if keyboard_check(vk_up) or keyboard_check(ord('W')) {
        if keyboard_check(vk_left) or keyboard_check(ord('A')) {
            direction = 135;
        }
        else if keyboard_check(vk_right) or keyboard_check(ord('D')) {
            direction = 45;
        }
        else {
            direction = 90;
        }
    }
    else if keyboard_check(vk_down) or keyboard_check(ord('S')) {
        if keyboard_check(vk_left) or keyboard_check(ord('A')) {
            direction = 225;
        }
        else if keyboard_check(vk_right) or keyboard_check(ord('D')) {
            direction = 315;
        }
        else {
            direction = 270;
        }
    }
    else {
        if keyboard_check(vk_left) or keyboard_check(ord('A')) {
            direction = 180;
        }
        else if keyboard_check(vk_right) or keyboard_check(ord('D')) {
            direction = 0;
        }
        else {
            direction = 1;
        }
    }
    if direction != 1 {
        var vv = dlt * m_unit_velocidad * 1.2;
        x += lengthdir_x(vv, direction);
        y += lengthdir_y(vv, direction);
    }
    
    // hacer salto temporal
    if energy_time >= m_enerunit {
        var ok = false;
        if keyboard_check_pressed(ord('E')) and g_tiempo < m_time_final {
            s_cambio_time(g_tiempo + 1);
            ok = true;
        }
        else if keyboard_check_pressed(ord('Q')) and g_tiempo > m_time_inicial {
            s_cambio_time(g_tiempo - 1);
            ok = true;
        }
        if ok {
            energy_time -= m_enerunit;
            var yo = id;
            for (var i = m_time_inicial; i <= m_time_final; i++) {
                with g_parent[i, m_par_warrior] {
                    if viajero {
                        viajero = false;
                        if yo.energy_time >= m_enerunit {
                            yo.energy_time -= m_enerunit;
                            s_viajetiempo(id, g_tiempo, true, false);
                        }
                    }
                }
                with g_parent[i, m_par_worker] {
                    if viajero {
                        viajero = false;
                        if yo.energy_time >= m_enerunit {
                            yo.energy_time -= m_enerunit;
                            s_viajetiempo(id, g_tiempo, false, false);
                        }
                    }
                }
            }
            s_viajetiempo(id, g_tiempo, true, true);
            return true;
        }
    }
}
return false;

