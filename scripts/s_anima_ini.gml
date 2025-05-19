///s_anima_ini(id, osciladores, hay_paso, hay_errar);
//inicializa las variables para animacion
//arg0: id instancia que llama
//arg1: numero de animaciones
//arg2: true si hay animacion de paso
//arg3: true si hay ciclo de errar IA

with argument0 {
    for (var i = 0; i < argument1; i++) {
        reloj_anima[i] = random(1);
        anima[i] = 0;
    }
    if argument2 {
        reloj_paso = random(1);
        paso = 0;
        reloj_pies = 0;
    }
    if argument3 {
        reloj_errar = random(1);
        mov_ia = choose(true, false);
        dir_ia = random(360);
    }
}

