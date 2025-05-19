///s_linea_agua(x1, y1, x2, y2);

var xx = argument0;
var yy = argument1;
var dis = point_distance(xx, yy, argument2, argument3);
var ang = point_direction(xx, yy, argument2, argument3);
var paso = dis / max(1, ceil(dis / m_celda));
for (var p = 0; p <= dis; p += paso) {
    xx += lengthdir_x(paso, ang);
    yy += lengthdir_y(paso, ang);
    if s_enagua(xx, yy) {
        return true;
    }
}
return false;

