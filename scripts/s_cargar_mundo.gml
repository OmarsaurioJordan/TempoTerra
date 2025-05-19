///s_cargar_mundo();

ini_open("mapa.ini");
// natural
var n = 0;
var xx, yy, tt, cc;
while ini_key_exists("natural", "c" + string(n)) {
    xx = real(ini_read_string("natural", "x" + string(n), "0"));
    yy = real(ini_read_string("natural", "y" + string(n), "0"));
    tt = real(ini_read_string("natural", "t" + string(n), "0"));
    cc = real(ini_read_string("natural", "c" + string(n), "0"));
    s_new_natural(cc, xx, yy, true, tt);
    n++;
}
// decorado
n = 0;
while ini_key_exists("decorado", "c" + string(n)) {
    xx = real(ini_read_string("decorado", "x" + string(n), "0"));
    yy = real(ini_read_string("decorado", "y" + string(n), "0"));
    tt = real(ini_read_string("decorado", "t" + string(n), "0"));
    cc = real(ini_read_string("decorado", "c" + string(n), "0"));
    s_new_natural(cc, xx, yy, false, tt);
    n++;
}
// cosa
n = 0;
while ini_key_exists("cosa", "c" + string(n)) {
    xx = real(ini_read_string("cosa", "x" + string(n), "0"));
    yy = real(ini_read_string("cosa", "y" + string(n), "0"));
    tt = real(ini_read_string("cosa", "t" + string(n), "0"));
    cc = real(ini_read_string("cosa", "c" + string(n), "0"));
    s_new_natural(cc, xx, yy, false, tt);
    n++;
}
// centro
n = 0;
while ini_key_exists("centro", "c" + string(n)) {
    xx = real(ini_read_string("centro", "x" + string(n), "0"));
    yy = real(ini_read_string("centro", "y" + string(n), "0"));
    tt = real(ini_read_string("centro", "t" + string(n), "0"));
    cc = real(ini_read_string("centro", "c" + string(n), "0"));
    s_new_edificio(cc, xx, yy, true, tt);
    n++;
}
// casa
n = 0;
while ini_key_exists("casa", "c" + string(n)) {
    xx = real(ini_read_string("casa", "x" + string(n), "0"));
    yy = real(ini_read_string("casa", "y" + string(n), "0"));
    tt = real(ini_read_string("casa", "t" + string(n), "0"));
    cc = real(ini_read_string("casa", "c" + string(n), "0"));
    s_new_edificio(cc, xx, yy, false, tt);
    n++;
}
// camino
n = 0;
while ini_key_exists("camino", "x" + string(n)) {
    xx = real(ini_read_string("camino", "x" + string(n), "0"));
    yy = real(ini_read_string("camino", "y" + string(n), "0"));
    instance_create(xx, yy, o_camino);
    n++;
}
// fin
ini_close();

