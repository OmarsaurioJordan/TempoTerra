///s_ini_combate();

with argument0 {
    switch grupo {
        case m_grupo_global:
            ataque = m_unit_ataque_futu;
            agilidad = m_unit_agilidad_futu;
            alcance = m_unit_alcance_futu;
            perforacion = m_unit_perfora_futu;
            cadencia = m_unit_cadencia_futu;
            municion_max = m_unit_municion_futu;
            provisiones_max = m_unit_provi_futu;
            break;
        case m_grupo_ruso:
        case m_grupo_america:
            ataque = m_unit_ataque_moder;
            agilidad = m_unit_agilidad_moder;
            alcance = m_unit_alcance_moder;
            perforacion = m_unit_perfora_moder;
            cadencia = m_unit_cadencia_moder;
            municion_max = m_unit_municion_moder;
            provisiones_max = m_unit_provi_moder;
            mochila_max = m_unit_granadas;
            break;
        case m_grupo_mexicano:
        case m_grupo_aleman:
        case m_grupo_ingles:
            ataque = m_unit_ataque_colon;
            agilidad = m_unit_agilidad_colon;
            alcance = m_unit_alcance_colon;
            perforacion = m_unit_perfora_colon;
            cadencia = m_unit_cadencia_colon;
            municion_max = m_unit_municion_colon;
            provisiones_max = m_unit_provi_colon;
            mochila_max = m_unit_dinamitas;
            break;
        case m_grupo_chino:
        case m_grupo_vikingo:
        case m_grupo_arabe:
        case m_grupo_castellano:
            ataque = m_unit_ataque_medi;
            agilidad = m_unit_agilidad_medi;
            alcance = m_unit_alcance_medi;
            perforacion = m_unit_perfora_medi;
            cadencia = m_unit_cadencia_medi;
            municion_max = m_unit_municion_medi;
            provisiones_max = m_unit_provi_medi;
            escudo = m_unit_escudito;
            dureza = m_unit_vida;
            break;
        case m_grupo_persa:
        case m_grupo_africano:
        case m_grupo_azteca:
        case m_grupo_egipcio:
        case m_grupo_griego:
            ataque = m_unit_ataque_impe;
            agilidad = m_unit_agilidad_impe;
            alcance = m_unit_alcance_impe;
            perforacion = m_unit_perfora_impe;
            cadencia = m_unit_cadencia_impe;
            municion_max = m_unit_municion_impe;
            provisiones_max = m_unit_provi_impe;
            escudo = m_unit_escudo;
            dureza = m_unit_vida / 2;
            break;
        default: // cavernarios
            ataque = m_unit_ataque_caver;
            agilidad = m_unit_agilidad_caver;
            alcance = m_unit_alcance_caver;
            perforacion = m_unit_perfora_caver;
            cadencia = m_unit_cadencia_caver;
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

