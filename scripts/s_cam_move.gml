///s_cam_move(cam_x, cam_y);
// arg0: posicion x mouse
// arg1: posicion y mouse
// debe existir la variable global clicdxy[]
// donde clicdxy[0], clicdxy[1] son x,y previos de clic

if clicdxy[0] != 0 and clicdxy[1] != 0 {
    view_xview[0] += clicdxy[0] - argument0;
    view_yview[0] += clicdxy[1] - argument1;
    s_cam_limit();
}
if mouse_check_button_pressed(mb_right) {
    clicdxy[0] = argument0;
    clicdxy[1] = argument1;
}
else if mouse_check_button_released(mb_right) {
    clicdxy[0] = 0;
    clicdxy[1] = 0;
}

