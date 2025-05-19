///s_create_warrior(id);
// Nota: no olvidar actualizar en s_viajetiempo al hacer cambios

with argument0 {
    rol = m_bla_war_dron;
    s_create_humano(id);
    
    // parametros y defensas
    modo_mele = random(1) < 0.5; // en que forma peleara mele o distancia
    escudo = 0; // probabilidad bloqueo
    dureza = 0; // puntos de vida del escudo
    
    // arma de mele
    ataque = 1; // cantidad de damage que hace
    agilidad = 1; // tiempo entre golpes
    reloj_ataque = agilidad;
    
    // arma de distancia
    //m_unit_falla_tiro es angulo azar errar para distancia
    alcance = 1; // fraccion del alcance visual hasta donde llega
    perforacion = 1; // cantidad de damage del proyectil
    cadencia = 1; // tiempo entre disparos
    reloj_cadencia = cadencia;
    municion_max = 0; // cantidad de disparos consecutivos
    municion = municion_max;
    reloj_recarga = m_unit_recarga;
    provisiones_max = 0; // cantidad de veces que puede recargar
    provisiones = provisiones_max;
    
    // arma secundaria
    // alcance es m_unit_lanza como fraccion de la vision
    reloj_preparacion = m_unit_recarga;
    mochila_max = 0; // cantidad de disparos secundarios
    mochila = mochila_max;
    
    // dron de ataque
    mi_dron = noone; // id del dron asociado
    
    s_debe_show(id);
}

