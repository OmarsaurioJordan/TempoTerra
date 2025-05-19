///s_cam_limit();

view_xview[0] = clamp(view_xview[0], 0, room_width - view_wview[0]);
view_yview[0] = clamp(view_yview[0], 0, room_height - view_hview[0]);
view_xview[0] = round(view_xview[0]);
view_yview[0] = round(view_yview[0]);

