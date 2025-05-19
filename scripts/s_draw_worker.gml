///s_draw_worker(id);

with argument0 {
    // pies
    if reloj_pies == 0 {
        draw_sprite_ext(d_pies, lospies + 1, x - 18, y, 0.8, 0.8, 0, c_white, 1);
        draw_sprite_ext(d_pies, lospies + 1, x + 18, y, 0.8, 0.8, 0, c_white, 1);
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
        draw_sprite_ext(d_pies, lospies + 1, x - 18, y - pai * 5, 0.8, 0.8, 0, c_white, 1);
        draw_sprite_ext(d_pies, lospies + 1, x + 18, y - pad * 5, 0.8, 0.8, 0, c_white, 1);
    }
    // cuerpo y cabeza
    draw_sprite(d_cuerpo, grupo * 2 + 1, x, y - 48 + anima[0]);
    draw_sprite(d_cabeza, grupo * 2 + 1, x, y - 48 - 90 + anima[0] + anima[1]);
    // izq
    if modo_trabajo {
        if grupo == m_grupo_global and mi_robot != noone {
            draw_sprite(d_secundaria, 2, x - 45, y - 48 + anima[0] + anima[2]);
        }
        else {
            draw_sprite(d_bolsa, labolsa, x - 50, y - 48 + anima[0] + anima[2]);
        }
    }
    // der
    if reloj_crecimiento != -1 {
        if reloj_crecimiento < m_unit_crecimiento * 0.8 {
            switch grupo {
                case m_grupo_global:
                    draw_sprite(d_huevo, 3, x + 30, y - 48 - 40 + anima[0] + anima[3]);
                    break;
                case m_grupo_ruso:
                case m_grupo_america:
                case m_grupo_ingles:
                case m_grupo_aleman:
                case m_grupo_mexicano:
                    draw_sprite(d_huevo, 2, x + 30, y - 48 - 40 + anima[0] + anima[3]);
                    break;
                case m_grupo_indoafro:
                case m_grupo_indoeuropeo:
                case m_grupo_indobabilonio:
                case m_grupo_indonordico:
                case m_grupo_indoamericano:
                case m_grupo_indoasiatico:
                case m_grupo_ninguno:
                    draw_sprite(d_huevo, 0, x + 30, y - 48 - 40 + anima[0] + anima[3]);
                    break;
                default:
                    draw_sprite(d_huevo, 1, x + 30, y - 48 - 40 + anima[0] + anima[3]);
                    break;
            }
        }
    }
    else if reloj_cocina != -1 {
        draw_sprite(d_alimento, 0, x + 25, y - 48 - 30 + anima[0] + anima[3]);
    }
    else if reloj_paseapan != -1 {
        draw_sprite(d_alimento, 1, x + 25, y - 48 - 30 + anima[0] + anima[3]);
    }
}

