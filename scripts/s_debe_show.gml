///s_debe_show(id);

with argument0 {
    var actual, padre;
    visible = false;
    mytime = -1;
    for (var i = m_time_inicial; i <= m_time_final; i++) {
        actual = g_parent[i, m_par_imagen];
        padre = object_get_parent(object_index);
        while padre != o_imagen {
            if padre == actual {
                if i == g_tiempo {
                    visible = true;
                }
                mytime = i;
                break;
            }
            padre = object_get_parent(padre);
        }
        if mytime != -1 {
            break;
        }
    }
}

