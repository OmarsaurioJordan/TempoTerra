///s_new_humano(tiempo, x, y, genero, grupo);

var aux;
// crear un objeto segun tiempo y genero
if argument3 == m_genero_fem {
    aux = instance_create(argument1, argument2, g_parent[argument0, m_par_worker]);
}
else {
    aux = instance_create(argument1, argument2, g_parent[argument0, m_par_warrior]);
}
// ponerle cosas especiales segun genero y grupo
with aux {
    grupo = argument4;
    alianza = grupo;
    // ajustarle parametros generales segun grupo
    switch grupo {
        case m_grupo_global:
            lospies = 10;
            labolsa = 5;
            armadura = m_unit_armadura_futu;
            break;
        case m_grupo_ruso:
        case m_grupo_america:
            lospies = 8;
            labolsa = 4;
            armadura = m_unit_armadura_moder;
            break;
        case m_grupo_mexicano:
        case m_grupo_aleman:
        case m_grupo_ingles:
            lospies = 6;
            labolsa = 3;
            armadura = m_unit_armadura_colon;
            break;
        case m_grupo_chino:
        case m_grupo_vikingo:
        case m_grupo_arabe:
        case m_grupo_castellano:
            lospies = 4;
            labolsa = 2;
            armadura = m_unit_armadura_medi;
            break;
        case m_grupo_persa:
        case m_grupo_africano:
        case m_grupo_azteca:
        case m_grupo_egipcio:
        case m_grupo_griego:
            lospies = 2;
            labolsa = 1;
            armadura = m_unit_armadura_impe;
            break;
    }
    // poner municion y herramientas a los warriors
    if argument3 == m_genero_masc {
        s_ini_combate(aux);
        // probabilidad modo de combate
        switch grupo {
            case m_grupo_global:
                modo_mele = random(1) < 0.5;
                break;
            case m_grupo_ruso:
            case m_grupo_america:
                modo_mele = random(1) < 0.1;
                break;
            case m_grupo_mexicano:
            case m_grupo_aleman:
            case m_grupo_ingles:
                modo_mele = random(1) < 0.2;
                break;
            case m_grupo_chino:
            case m_grupo_vikingo:
            case m_grupo_arabe:
            case m_grupo_castellano:
                modo_mele = random(1) < 0.6;
                break;
            case m_grupo_persa:
            case m_grupo_africano:
            case m_grupo_azteca:
            case m_grupo_egipcio:
            case m_grupo_griego:
                modo_mele = random(1) < 0.3;
                break;
            default: // cavernarios
                modo_mele = random(1) < 0.9;
                break;
        }
    }
    else {
        mi_casa = collision_point(x, y, g_parent[argument0, m_par_casa], true, false);
        // modificar armaduras a feminas
        switch grupo {
            case m_grupo_vikingo:
                armadura = m_unit_armadura_medi;
                break;
            case m_grupo_global:
                armadura = m_unit_armadura_futfem;
                break;
            default:
                armadura = 0;
                break;
        }
    }
}
return aux;

