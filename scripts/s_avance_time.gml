///s_avance_time(al_pasado);

if argument0 {
    if g_tiempo > m_time_inicial {
        s_cambio_time(g_tiempo - 1);
    }
}
else {
    if g_tiempo < m_time_final {
        s_cambio_time(g_tiempo + 1);
    }
}

