///s_step_warrior(id);

with argument0 {
    var antx = x;
    var anty = y;
    if esplayer {
        if s_step_player(id) {
            exit;
        }
        s_step_humano(id, antx, anty);
        break;
    }
    // inicio
    
    // fin
    s_step_humano(id, antx, anty);
}

