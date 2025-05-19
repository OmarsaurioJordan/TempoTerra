///s_recarga(id, poner_escudo, dar_maquina);
// rellena la municion

with argument0 {
    switch grupo {
        case m_grupo_global:
            municion_max = m_unit_municion_futu;
            provisiones_max = m_unit_provi_futu;
            if argument2 {
                // Tarea crear dron o robot
            }
            break;
        case m_grupo_ruso:
        case m_grupo_america:
            municion_max = m_unit_municion_moder;
            provisiones_max = m_unit_provi_moder;
            mochila_max = m_unit_granadas;
            break;
        case m_grupo_mexicano:
        case m_grupo_aleman:
        case m_grupo_ingles:
            municion_max = m_unit_municion_colon;
            provisiones_max = m_unit_provi_colon;
            mochila_max = m_unit_dinamitas;
            break;
        case m_grupo_chino:
        case m_grupo_vikingo:
        case m_grupo_arabe:
        case m_grupo_castellano:
            municion_max = m_unit_municion_medi;
            provisiones_max = m_unit_provi_medi;
            if argument1 {
                escudo = m_unit_escudito;
                dureza = m_unit_vida;
            }
            break;
        case m_grupo_persa:
        case m_grupo_africano:
        case m_grupo_azteca:
        case m_grupo_egipcio:
        case m_grupo_griego:
            municion_max = m_unit_municion_impe;
            provisiones_max = m_unit_provi_impe;
            if argument1 {
                escudo = m_unit_escudo;
                dureza = m_unit_vida / 2;
            }
            break;
        default: // cavernarios
            municion_max = m_unit_municion_caver;
            provisiones_max = m_unit_provi_caver;
            break;
    }
    reloj_ataque = agilidad;
    reloj_cadencia = cadencia;
    municion = municion_max;
    reloj_recarga = m_unit_recarga;
    provisiones = provisiones_max;
    reloj_preparacion = m_unit_recarga;
    mochila = mochila_max;
}

