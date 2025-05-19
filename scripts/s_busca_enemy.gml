///s_busca_enemy(id);

var xx = argument0.x;
var yy = argument0.y;
var ali = argument0.alianza;
var tt = argument0.mytime;
var mej_id = noone;
var mej_dis = m_unit_vision;
var dis;
with g_parent[tt, m_par_movil] {
    if rol != m_bla_mons_alien {
        continue;
    }
    dis = point_distance(x, y, xx, yy);
    if dis < mej_dis {
        if !collision_line(x, y, xx, yy,
                g_parent[tt, m_par_bloque], true, false) {
            if !s_linea_agua(x, y, xx, yy) {
                mej_dis = dis;
                mej_id = id;
            }
        }
    }
}
if mej_id == noone {
    with g_parent[tt, m_par_movil] {
        if rol != m_bla_war_dron {
            continue;
        }
        if alianza == ali {
            continue;
        }
        dis = point_distance(x, y, xx, yy);
        if dis < mej_dis {
            if !collision_line(x, y, xx, yy,
                    g_parent[tt, m_par_bloque], true, false) {
                if !s_linea_agua(x, y, xx, yy) {
                    mej_dis = dis;
                    mej_id = id;
                }
            }
        }
    }
}
argument0.enemy[0] = mej_id;

