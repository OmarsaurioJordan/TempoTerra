# Tareas

- solo puede obtener armas en su base aliada, debe tomar pan de su era futurista, ahí lo lleva a obrera para aliarse, una alianza posible por era, tiene tiempo limitado para entregar el pan o desaparece desligando bases si hay más de una y mostrando el mensaje correspondiente ante cualquier cambio, también se cura en base futurista
...
- si centro unico, nunca guerra ni ataque, quizás defensa si enemigos en torno a centro
- si guerra y otro no tiene soldados, terminarla.
...
- poner en obrera modo de huida cuando sea atacada
- al tener objetivo a atacar, este auto contraataca si no tiene otro objetivo
- al ser atacado recluta aliado cercano, help, sea obrera o warrior
- respawn de player con animacion
- hacer que entes seleccionados sigan, solo si aliados
- verificar eliminación de entes que no tengan base en un tiempo que no sea el suyo, timer global
- caminan lento cuando recargando
- tiempo de recarga puede aumentarse para demora cuando toman municion de sus bases
- cargar municion no debe cambiar mele por obsoleta, ni escudo ni explosivos, excepto player
- si luchando y obrera muy cerca, dejar de seguir obrera para recuperar vida
- las particulas cambio era blancas se están abriendo cada vez más
- no quieren recargar explosivo aunque bobean cerca a la base
...
- insectos errar
- player ataque mele
- player ataque especial
- player cambio de armas
- player mouse mueve camara
- player recolección de relojes
- entes con dialogos contextuales
- entes pueden crear robots o drones
- audio: efectos de sonido
- audio: música contextual
- menú principal, juego nuevo o continuar
- pausa, opciónes sonido y salir
- construir todos los mundos, diseño de nivel
...
- hay una escena Monigote, para vestirle

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
