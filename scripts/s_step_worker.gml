///s_step_worker(id);

with argument0 {
    var antx = x;
    var anty = y;
    
    // rebotar con bloques y moviles
    s_colision(id, true);
    
    // buscar objetivo siempre
    if random(1) < 0.1 {
        s_busca_enemy(id);
    }
    
    // cambiar de giro
    reloj_giro -= dlt;
    if reloj_giro <= 0 {
        reloj_giro = random_range(2, 5);
        giro_desvio = random_range(-90, 90);
    }
    
    // modo huida
    if enemy[0] != noone {
        if instance_exists(enemy[0]) {
            enemy[1] = enemy[0].x;
            enemy[2] = enemy[0].y;
            enemy[3] = 4;
        }
        else {
            enemy[0] = noone;
        }
    }
    if enemy[1] != 0 {
        // ejecutar huida
        direction = point_direction(enemy[1], enemy[2], x, y) +
            giro_desvio;
        var v = m_unit_velocidad * dlt;
        x += lengthdir_x(v, direction);
        y += lengthdir_y(v, direction);
        if point_distance(enemy[1], enemy[2], x, y) > m_unit_vision {
            enemy[1] = 0;
            enemy[3] = 4;
        }
        else {
            // finalizar huida por tiempo
            enemy[3] -= dlt;
            if enemy[3] <= 0 {
                enemy[1] = 0;
                enemy[3] = 4;
            }
        }
    }
    // trabajar en alimentacion
    else if modo_trabajo {
        
    }
    // procreacion
    else {
        reloj_crecimiento -= dlt;
        if reloj_crecimiento <= 0 {
            reloj_crecimiento = -1;
            modo_trabajo = true;
            // nuevo humano
            var casas = 0;
            var wrk = 0;
            var wrr = 0;
            var yo = id;
            with g_parent[mytime, m_par_casa] {
                if grupo == yo.alianza {
                    casas++;
                }
            }
            if casas != 0 {
                with g_parent[mytime, m_par_worker] {
                    if alianza == yo.alianza {
                        wrk++;
                    }
                }
                with g_parent[mytime, m_par_warrior] {
                    if alianza == yo.alianza {
                        wrr++;
                    }
                }
                wrk = max(0, casas - wrk);
                wrr = max(0, casas * 2 - wrr);
                if wrk != 0 or wrr != 0 {
                    var gn = m_genero_fem;
                    if wrk != 0 and wrr == 0 {
                        gn = m_genero_fem;
                    }
                    else if wrk == 0 and wrr != 0 {
                        gn = m_genero_masc;
                    }
                    else if random(1) < wrr / (wrk + wrr) {
                        gn = m_genero_masc;
                    }
                    s_new_humano(mytime, x + random_range(-1, 1),
                        y + random_range(-1, 1), gn, alianza);
                }
            }
        }
        // caminar mientras se gesta
        if reloj_espera == 0 {
            if mx == 0 {
                // elegir punto
                var css = ds_list_create();
                var yo = id;
                with g_parent[mytime, m_par_casa] {
                    if grupo == yo.alianza {
                        ds_list_add(css, id);
                    }
                }
                if !ds_list_empty(css) {
                    ds_list_shuffle(css);
                    var c = ds_list_find_value(css, 0);
                    var r, g;
                    do {
                        r = random(m_unit_vision);
                        g = random(360);
                        mx = c.x + lengthdir_x(r, g);
                        my = c.y + lengthdir_y(r, g);
                    }
                    until !s_enagua(mx, my) and
                        !place_meeting(mx, my, g_parent[mytime, m_par_bloque]);
                }
                ds_list_destroy(css);
            }
            else {
                // ir a punto
                if random(1) < 0.1 {
                    es_lineagua = s_linea_agua(x, y, mx, my);
                }
                if !es_lineagua {
                    direction = point_direction(x, y, mx, my) +
                        giro_desvio / 2;
                }
                else {
                    if el_camino == noone {
                        var md = 100000;
                        var d;
                        var yo = id;
                        with o_camino {
                            if !s_linea_agua(x, y, yo.mx, yo.my) {
                                d = point_distance(x, y, yo.mx, yo.my);
                                if d < md {
                                    md = d;
                                    yo.el_camino = id;
                                }
                            }
                        }
                    }
                    direction = s_rumbo(el_camino.rumbo, x, y);
                }
                var v = m_unit_velocidad * dlt;
                x += lengthdir_x(v, direction);
                y += lengthdir_y(v, direction);
                if point_distance(x, y, mx, my) < m_celda {
                    mx = 0;
                    reloj_espera = random_range(6, 12);
                }
            }
        }
        else {
            reloj_espera = max(0, reloj_espera - dlt);
        }
    }
    
    // fin
    s_step_humano(id, antx, anty);
}

