///s_draw_warrior(id);

with argument0 {
    // pies
    var piesitos = d_pies;
    if esplayer {
        piesitos = d_player;
    }
    if reloj_pies == 0 {
        draw_sprite_ext(piesitos, lospies, x - 18, y, 0.8, 0.8, 0, c_white, 1);
        draw_sprite_ext(piesitos, lospies, x + 18, y, 0.8, 0.8, 0, c_white, 1);
    }
    else {
        var pai, pad;
        switch paso {
            case 1: pai = 0; pad = 6; break;
            case 2: pai = 2; pad = 4; break;
            case 3: pai = 4; pad = 2; break;
            case 4: pai = 6; pad = 0; break;
            case 5: pai = 4; pad = 2; break;
            case 0: pai = 2; pad = 4; break;
        }
        draw_sprite_ext(piesitos, lospies, x - 18, y - pai * 5, 0.8, 0.8, 0, c_white, 1);
        draw_sprite_ext(piesitos, lospies, x + 18, y - pad * 5, 0.8, 0.8, 0, c_white, 1);
    }
    // cuerpo y cabeza
    if esplayer {
        draw_sprite(d_player, 1, x, y - 48 + anima[0]);
        draw_sprite(d_player, 0, x, y - 48 - 90 + anima[0] + anima[1]);
    }
    else {
        draw_sprite(d_cuerpo, grupo * 2, x, y - 48 + anima[0]);
        draw_sprite(d_cabeza, grupo * 2, x, y - 48 - 90 + anima[0] + anima[1]);
    }
    // izq
    if !modo_mele and grupo < m_grupo_griego and grupo != m_grupo_ninguno {
        if municion != 0 {
            draw_sprite(d_distancia, 1, x - 40, y - 48 + anima[0] + anima[2]);
        }
    }
    else if grupo >= m_grupo_griego and grupo <= m_grupo_persa {
        if dureza != 0 {
            draw_sprite(d_escudo, grupo, x - 30, y - 48 + anima[0] + anima[2]);
        }
    }
    else if grupo >= m_grupo_castellano and grupo <= m_grupo_chino {
        if modo_mele {
            if dureza != 0 {
                draw_sprite(d_escudo, grupo, x - 30, y - 48 + anima[0] + anima[2]);
            }
        }
        else {
            if municion != 0 {
                draw_sprite(d_distancia, 3, x - 40, y - 48 + anima[0] + anima[2]);
            }
        }
    }
    else if modo_mele and grupo >= m_grupo_ingles and grupo <= m_grupo_mexicano {
        if mochila != 0 {
            draw_sprite(d_secundaria, 0, x - 40, y - 48 + anima[0] + anima[2]);
        }
    }
    else if modo_mele and grupo >= m_grupo_america and grupo <= m_grupo_ruso {
        if mochila != 0 {
            draw_sprite(d_secundaria, 1, x - 40, y - 48 + anima[0] + anima[2]);
        }
    }
    else if modo_mele and grupo == m_grupo_global {
        if mi_dron != noone {
            draw_sprite(d_secundaria, 2, x - 50, y - 48 + anima[0] + anima[2]);
        }
    }
    // der
    if grupo < m_grupo_griego and grupo != m_grupo_ninguno {
        if modo_mele {
            draw_sprite_ext(d_mele, grupo, x + 20, y - 48 + anima[0] + anima[3],
                1, 1, -20, c_white, 1);
        }
        else if municion != 0 {
            draw_sprite(d_distancia, 0, x + 35, y - 48 + anima[0] + anima[3]);
        }
    }
    else if grupo >= m_grupo_griego and grupo <= m_grupo_persa {
        if modo_mele {
            draw_sprite_ext(d_mele, grupo, x + 20, y - 48 + anima[0] + anima[3],
                1, 1, -20, c_white, 1);
        }
        else if municion != 0 {
            draw_sprite(d_distancia, 2, x + 35, y - 48 + anima[0] + anima[3]);
        }
    }
    else if grupo >= m_grupo_castellano and grupo <= m_grupo_chino {
        if modo_mele {
            draw_sprite_ext(d_mele, grupo, x + 25, y - 48 + anima[0] + anima[3],
                1, 1, -20, c_white, 1);
        }
        else {
            draw_sprite(d_distancia, 4, x + 40, y - 48 + anima[0] + anima[3]);
        }
    }
    else if grupo >= m_grupo_ingles and grupo <= m_grupo_mexicano {
        if modo_mele {
            if grupo == m_grupo_mexicano {
                draw_sprite_ext(d_mele, grupo, x + 20, y - 48 + anima[0] + anima[3],
                    1, 1, -20, c_white, 1);
            }
            else {
                draw_sprite_ext(d_mele, grupo, x + 25, y - 48 + anima[0] + anima[3],
                    1, 1, -20, c_white, 1);
            }
        }
        else if grupo == m_grupo_aleman {
            draw_sprite(d_distancia, 6, x + 40, y - 48 + anima[0] + anima[3]);
        }
        else {
            draw_sprite(d_distancia, 5, x + 40, y - 48 + anima[0] + anima[3]);
        }
    }
    else if grupo >= m_grupo_america and grupo <= m_grupo_ruso {
        if modo_mele {
            draw_sprite_ext(d_mele, grupo, x + 25, y - 48 + anima[0] + anima[3],
                1, 1, -20, c_white, 1);
        }
        else if grupo == m_grupo_america {
            draw_sprite(d_distancia, 7, x + 40, y - 48 + anima[0] + anima[3]);
        }
        else {
            draw_sprite(d_distancia, 8, x + 40, y - 48 + anima[0] + anima[3]);
        }
    }
    else if grupo == m_grupo_global {
        if modo_mele {
            draw_sprite_ext(d_mele, grupo, x + 25, y - 48 + anima[0] + anima[3],
                1, 1, -20, c_white, 1);
        }
        else {
            draw_sprite(d_distancia, 9, x + 40, y - 48 + anima[0] + anima[3]);
        }
    }
}

