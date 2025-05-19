///s_create_humano(id);
// Nota: no olvidar actualizar en s_viajetiempo al hacer cambios

with argument0 {
    
    // parametros
    esplayer = false; // si sera manejado manualmente
    grupo = m_grupo_ninguno; // su origen, visual y no cambiable
    alianza = grupo; // actualmente del lado de quien pelea
    vida = m_unit_vida; // puntos de impacto antes de morir
    armadura = 0; // porcentaje disminucion de damage
    reloj_curar = 0; // m_unit_curar tiempo curar 1 punto vida
    viajero = false; // si ha sido sennalado para viajar en tiempo, nunca player
    
    // visual
    s_anima_ini(id, 4, true, true); // 0:cuerpo, 1:cabeza, 2:izq, 3:der
    lospies = 0; // tipos de pies, autopuesto
    labolsa = 0; // bolsa de worker, autopuesto
    depth = -y;
    
    // IA
    enemy[0] = noone; // id de enemigo visto
    enemy[1] = 0; // x,y ultima vez vio enemigo
    enemy[2] = 0;
    enemy[3] = 4; // tiempo para olvidarlo
    reloj_giro = 0; // para hacer cambios de movimiento
    giro_desvio = 0;
    reloj_espera = 0; // para estar quieto
    es_lineagua = false; // dice si el camino esta en linea agua, random time
    mx = 0; // punto a alcanzar
    my = 0;
    el_camino = noone; // id de o_camino a seguir
}

