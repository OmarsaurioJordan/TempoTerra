///s_anima_paso(id, periodo, num_pasos);
//reloj de animacion para sprites de subimagenes
//arg0: id instancia que llama
//arg1: tiempo entre pasos
//arg2: cuantas sub-imagenes son

with argument0 {
    // dar el paso
    reloj_paso += dlt;
    while reloj_paso >= argument1 {
        reloj_paso -= argument1;
        paso++;
        if paso >= argument2 {
            paso = 0;
        }
    }
    // suavizar cambios
    if x != xprevious or y != yprevious {
        reloj_pies = 0.25;
    }
    else {
        reloj_pies = max(0, reloj_pies - dlt);
    }
}

