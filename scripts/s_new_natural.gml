///s_new_natural(tiempo, x, y, es_bloque, tipo);

var aux;
if argument3 {
    aux = instance_create(argument1, argument2, g_parent[argument0, m_par_natural]);
}
else if argument4 == 10 {
    aux = instance_create(argument1, argument2, g_parent[argument0, m_par_cosa]);
}
else {
    aux = instance_create(argument1, argument2, g_parent[argument0, m_par_decorado]);
}
// ponerle cosas especiales segun tipo
aux.tipo = argument4;
return aux;

