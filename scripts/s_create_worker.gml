///s_create_worker(id);
// Nota: no olvidar actualizar en s_viajetiempo al hacer cambios

with argument0 {
    rol = m_bla_wor_robot;
    s_create_humano(id);
    
    // parametros y defensas
    mi_casa = noone; // id de la casa a la que pertenece
    modo_trabajo = random(1) < 0.5; // si trabaja o procrea
    
    // procreacion
    reloj_crecimiento = -1; // -1:inactivo, m_unit_crecimiento demora embarazo
    
    // recursos obtencion
    alimento = 0; // cuando llega a m_unit_alimento puede procrear
    reloj_cocina = -1; // m_unit_cocina para convertir cultivo en pan, -1 sin cultivo
    reloj_paseapan = -1; // m_unit_paseapan para poder usar pan, -1 sin pan
    
    // robot de trabajo
    mi_robot = noone; // id del robot asociado
    
    s_debe_show(id);
}

