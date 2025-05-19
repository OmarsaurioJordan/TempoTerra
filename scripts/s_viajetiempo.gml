///s_viajetiempo(id, new_time, es_masc, es_player);

with argument0 {
    // crear nueva instancia
    var aux;
    if argument2 {
    if argument3 {
        // player
        aux = s_new_player(argument1, x, y, grupo);
    }
    else {
        // warrior
        aux = s_new_humano(argument1, x, y, m_genero_masc, grupo);
    } }
    else {
        // worker
        aux = s_new_humano(argument1, x, y, m_genero_fem, grupo);
        // poner cosas de worker
        aux.modo_trabajo = modo_trabajo;
        aux.reloj_crecimiento = reloj_crecimiento;
        aux.alimento = alimento;
        aux.reloj_cocina = reloj_cocina;
        aux.reloj_paseapan = reloj_paseapan;
        // Tarea teleportar robot si tiene uno
    }
    // poner cosas generales de humano
    aux.alianza = alianza;
    aux.vida = vida;
    aux.armadura = armadura;
    aux.reloj_curar = reloj_curar;
    // poner cosas generales de warrior
    if argument2 {
        aux.modo_mele = modo_mele;
        aux.escudo = escudo;
        aux.dureza = dureza;
        aux.ataque = ataque;
        aux.agilidad = agilidad;
        aux.reloj_ataque = reloj_ataque;
        aux.alcance = alcance;
        aux.perforacion = perforacion;
        aux.cadencia = cadencia;
        aux.reloj_cadencia = reloj_cadencia;
        aux.municion_max = municion_max;
        aux.municion = municion;
        aux.reloj_recarga = reloj_recarga;
        aux.provisiones_max = provisiones_max;
        aux.provisiones = provisiones;
        aux.reloj_preparacion = reloj_preparacion;
        aux.mochila_max = mochila_max;
        aux.mochila = mochila;
        // Tarea teleportar el dron si tiene uno
    }
    // destruir copia del anterior
    instance_destroy();
}

