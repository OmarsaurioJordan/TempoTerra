# Tareas

- bases no están elijiendo base enemiga objetivo...
- base futurista es la misma en estadisticas que apocaliptica, hacer algo...
- casas medievales quitarles más marcador a zona de conexión con tierra
...
- crear explosivos, falta poner lanzador en ente
- daño hecho por proyectil
- daño hecho por mele
- daño hecho por explosivo
- bailewar agregar aleatoriedad en comportamiento mele, estan muy trompos
- ir a recargar municion
- ir a recargar vida
- poner en obrera modo de huida cuando sea atacada
- nuevos seres se crean sin ninguna municion ni arma
- al tener objetivo a atacar, este auto contraataca si no tiene otro objetivo
- al ser atacado recluta aliado cercano, help, sea obrera o warrior
- respawn de player con animacion
- deseleccionar entes si estan muy lejos
- hacer que entes seleccionados sigan, solo si aliados
- cambiar de era a los entes
- envejecerlos y kill si sobrepasan limite
- dibujar sprites de salvajes y su centro
...
- insectos: errar
- player: ataque mele
- player: ataque especial
- player: cambio de armas
- player: recolección de relojes
- entes: dialogos contextuales
- entes: crear robots o drones
- audio: efectos de sonido
- audio: música contextual
- menú: estructura visual main menú
- menú: de pausa, opciónes sonido y salir
- menú: poder iniciar juego nuevo o guardado
- mundos: colocar casas y centros
- mundos: colocar decorados naturales
- entes: manejo manual por segundo player
- entes: ajustar estadísticas de daño y eficiencia
- menú: escritos sobre los diferentes grupos en inglés

# Comportamiento

## Obrera

- si no hay obreras en mundo, crear una lejos del player
*  recolectar comida
*  convertir a comida procesada
*  curar aliado cercano
* generar nuevo aliado dependiendo de hogar no de grupo origen
* charlar con otra obrera
* caminar errando por su casa
- seguir a warrior para cambio de grupo, si no hay quien la proteja, ni dejar la base sola
- enviar robot a recolectar lejos

## Warrior

* caminar errando por su casa
- atacar con mele a enemigo cercano
- atacar a distancia a enemigo cercano
- atacar con explosivos a enemigos cercanos
- atacar con dron a enemigo lejano
* explorar libremente el mundo
* ir a atacar a punto especifico
- conquistar obrera para llevarla a su grupo, prioridad mismo origen sobre otras (rescate)
- asociarse a grupo si no tiene el suyo (viaje tiempo)
- volver a casa por munición de distancia, explosivo, curacion o dron
- atacar obrera si sobrepasa limite de su base y de la propia

# Alien

- moverse errando por el mundo
- atacar a criatura cercana
- ponerse en modo división reproductiva

# Monstruo

- moverse errando por el mundo
- atacar a presa cercana si tiene hambre
- comer cadaver para recuperarse y poner huevo
- cuidar huevo un tiempo
- huir si la cantidad de enemigos es muy alta

# Animal

- moverse errando por el mundo
- comer helecho cercano si tiene hambre, para poner huevo
- cuidar huevo un tiempo
- alejarse de otros no animales

# Robot

- errar en torno a obrera
- recolección y transformación en pan
- alimentación, incluye sobrealimentar obrera para reproducir

# Dron

- errar en torno a warrior
- ataque a objetivo a larga distancia

# Colisiones

- 0: layer 1, orilla del mar
- 1: layer 2, edificaciones: bases + casas
- 2: layer 3, naturales: arboles, rocas
- 3: layer 4, entes móviles, como humanos, player, animales, robots
- 4: layer 5, proyectiles
- 5: layer 6, indicadores amarillos de interaccion con bases
- 6: layer 7, igual que layer 2 + 3 pero para area que detiene proyectiles

# Prioridades Ataque

- 1 aliens
- 2 monstruos
- 3 warriors + players
- 4 drons
- 5 robots
- 6 obreras

# Imágenes

- imagenes: escaneo 300pp PNG
- photoshop contraste +30
- photoshop desplazamiento -0.05
- - photoshop gamma +0.9
- photoshop intensidad +30
- escalado de imágenes 50%

# Comandos

* W,A,S,D: movimiento a pie
* Q,E: viaje temporal
- Lclic: disparar principal
- Rclic: disparo secundaria
- Mclic,R: recarga municion
- Enter: tomar herramientas de la base, pasando por neutral
- Space: select / deselect compañeros viaje temporal
- Tab: ver dialogo de personaje
- Esc: pausa y salir
