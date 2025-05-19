///s_step_humano(id, antx, anty);
// recibe los pasos x,y dados anteriormente que se sabe estan en tierra

with argument0 {
    // verificar que no entre al agua
    if s_enagua(x, y) {
        var vv = random(m_unit_velocidad * dlt);
        direction = random(360);
        x = argument1 + lengthdir_x(vv, direction);
        y = argument2 + lengthdir_y(vv, direction);
        if s_enagua(x, y) {
            x = argument1;
            y = argument2;
        }
    }
    // animaciones
    if visible {
        s_anima_osc(id, 0, 2.4, 6); // cuerpo
        s_anima_osc(id, 1, 2.1, 4); // cabeza
        s_anima_osc(id, 2, 1.7, 7); // izq
        s_anima_osc(id, 3, 1.9, 7); // der
        s_anima_paso(id, 0.1, 6); // pies
        depth = -y;
    }
}

