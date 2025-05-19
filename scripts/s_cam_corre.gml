///s_cam_corre(direction, velocity);
// arg0: direccion de movimiento
// arg1: velocidad con delta

view_xview[0] += lengthdir_x(argument1, argument0);
view_yview[0] += lengthdir_y(argument1, argument0);
s_cam_limit();

