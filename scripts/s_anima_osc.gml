///s_anima_osc(id, ind_ani, periodo, med_amplitud);
//reloj de animacion para movimientos oscilantes
//arg0: id instancia que llama
//arg1: id de la animacion
//arg2: periodo de la animacion
//arg3: media amplitud del movimiento

with argument0 {
    reloj_anima[argument1] += dlt;
    while reloj_anima[argument1] >= argument2 {
        reloj_anima[argument1] -= argument2;
    }
    var prop = reloj_anima[argument1] / argument2;
    anima[argument1] = argument3 * sin(prop * 2 * pi);
}

