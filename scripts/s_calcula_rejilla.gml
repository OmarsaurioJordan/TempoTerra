///s_calcula_rejilla(x, y);
// arg0: destino x
// arg1: destino y

// datos generales de la rejilla
var wmax = ds_grid_width(ds_mapa);
var hmax = ds_grid_height(ds_mapa);
var zona = ds_grid_create(wmax, hmax);
ds_grid_clear(zona, -1);
for (var w = 0; w < wmax; w++) {
    for (var h = 0; h < hmax; h++) {
        if ds_grid_get(ds_mapa, w, h) {
            ds_grid_set(zona, w, h, 1);
        }
    }
}
var mx = round(argument0 / m_celda);
var my = round(argument1 / m_celda);
// crear rejilla de rumbo
var rumbo = ds_grid_create(wmax, hmax);
ds_grid_clear(rumbo, m_sinpaso);
ds_grid_set(rumbo, mx, my, 0);
// ejecutar ciclo de calculos
ds_grid_set(zona, mx, my, 0);
var lista = ds_queue_create();
ds_queue_enqueue(lista, mx, my);
var vx, vy, vz, vp, cp;
var veci = ds_queue_create();
while !ds_queue_empty(lista) {
    mx = ds_queue_dequeue(lista);
    my = ds_queue_dequeue(lista);
    if mx > 0 {
        ds_queue_enqueue(veci, mx - 1, my);
    }
    if mx < wmax - 1 {
        ds_queue_enqueue(veci, mx + 1, my);
    }
    if my > 0 {
        ds_queue_enqueue(veci, mx, my - 1);
    }
    if my < hmax - 1 {
        ds_queue_enqueue(veci, mx, my + 1);
    }
    while !ds_queue_empty(veci) {
        vx = ds_queue_dequeue(veci);
        vy = ds_queue_dequeue(veci);
        vz = ds_grid_get(zona, vx, vy);
        if vz != -1 {
            vp = ds_grid_get(rumbo, vx, vy);
            cp = ds_grid_get(rumbo, mx, my);
            if vz + cp < vp {
                ds_grid_set(rumbo, vx, vy, vz + cp);
                ds_queue_enqueue(lista, vx, vy);
            }
        }
    }
}
ds_queue_destroy(lista);
ds_queue_destroy(veci);
ds_grid_destroy(zona);
return rumbo;

