///s_grupo_to_time(ind_grupo);

switch argument0 {
    case m_grupo_global:
        return m_time_futurista;
    case m_grupo_america:
    case m_grupo_ruso:
        return m_time_moderna;
    case m_grupo_mexicano:
    case m_grupo_aleman:
    case m_grupo_ingles:
        return m_time_colonial;
    case m_grupo_chino:
    case m_grupo_vikingo:
    case m_grupo_arabe:
    case m_grupo_castellano:
        return m_time_medieval;
    case m_grupo_azteca:
    case m_grupo_africano:
    case m_grupo_egipcio:
    case m_grupo_griego:
    case m_grupo_persa:
        return m_time_imperial;
    case m_grupo_indoasiatico:
    case m_grupo_indoamericano:
    case m_grupo_indonordico:
    case m_grupo_indobabilonio:
    case m_grupo_indoeuropeo:
    case m_grupo_indoafro:
        return m_time_cavernaria;
    default:
        return m_time_prehistoria;
}

