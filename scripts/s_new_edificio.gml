///s_new_edificio(tiempo, x, y, es_centro, tipo);

var aux;
if argument3 {
    aux = instance_create(argument1, argument2, g_parent[argument0, m_par_centro]);
}
else {
    aux = instance_create(argument1, argument2, g_parent[argument0, m_par_casa]);
}
// ponerle cosas especiales segun tipo
aux.grupo = argument4;
if !argument3 {
    aux.tipo = s_grupo_to_time(aux.grupo);
}
return aux;

