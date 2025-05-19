///s_cambio_time(new_time);

g_tiempo = argument0;
// mostrar solo tiles deseados
for (var s = 900; s < 970; s++) {
    tile_layer_hide(s);
}
switch g_tiempo {
    case m_time_inicial:
        for (var s = 900; s < 910; s++) {
            tile_layer_show(s);
        }
        break;
    case m_time_prehistoria:
        for (var s = 910; s < 920; s++) {
            tile_layer_show(s);
        }
        break;
    case m_time_colonial:
        for (var s = 930; s < 940; s++) {
            tile_layer_show(s);
        }
        break;
    case m_time_moderna:
        for (var s = 940; s < 950; s++) {
            tile_layer_show(s);
        }
        break;
    case m_time_futurista:
        for (var s = 950; s < 960; s++) {
            tile_layer_show(s);
        }
        break;
    case m_time_final:
        for (var s = 960; s < 970; s++) {
            tile_layer_show(s);
        }
        break;
    default: // cavernario, imperial, medieval
        for (var s = 920; s < 930; s++) {
            tile_layer_show(s);
        }
        break;
}
// mostrar solo imagenes deseadas
with o_imagen {
    visible = false;
}
with g_parent[g_tiempo, m_par_imagen] {
    visible = true;
}

