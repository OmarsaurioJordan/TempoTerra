# Tareas

- objeto: arma o herramienta que puede caer al suelo
- diplomacia: poner el estado defensivo
- diplomacia: ejecutar ataque masivo
- diplomacia: ordenar cese al fuego
- proyectil: movimiento
- proyectil: impacto
- proyectil: explosion
- warriors: movimiento
- warriors: ataque distancia
- warriors: ataque mele
- obreras: movimiento
- obreras: reproducción
- obreras: recolección
- robots: recolección
- drones: ataque
- animales: movimiento
- animales: ataque
- animales: repdroducción
- insectos: errar
- alienígenas: movimiento
- alienígenas: ataque
- alienígenas: reproducción
- player: ataque distancia
- player: ataque mele
- player: ataque especial
- player: cambio de armas
- player: recolección de relojes
- entes: dialogos contextuales
- entes: sombras
- entes: muerte animada
- entes: crear robots o drones
- entes: viaje temporal
- entes: conversión a otra cultura
- audio: efectos de sonido
- audio: música contextual
- menú: estructura visual main menú
- menú: de pausa, opciónes sonido y salir
- menú: poder iniciar juego nuevo o guardado
- mundos: colocar casas y centros
- mundos: colocar decorados naturales
- entes: manejo manual por segundo player
- entes: ajustar estadísticas de daño y eficiencia

# Hecho

- sprites: dibujar personaje de portada
- sprites: dibujar mapas, suelo, decorados, edificios, objetos, personajes
- proyecto: organizado en sus carpetas
- proyecto: configuracion básica y de mapas de entrada
- mundos: estructura base de todos los mundos
- mundos: colisión con bordes del mar, static
- mundos: tiles del suelo segun tiempo
- entes: estructura de sprites
- player: movimiento
- naturales: estructurar decorados y árboles
- edificios: estructurar edificaciones de vivienda o centros
- player: viaje temporal
- entes: animación de sprites
- mundos: creación inicial de unidades

# Comportamiento

## Obrera

- si no hay obreras en mundo, crear una lejos del player
- si hay exceso de obreras para las casas, eliminarlas, ver original vs otra tirbu vs visita
- x recolectar comida
- x convertir a comida procesada
- x curar aliado cercano
- generar nuevo aliado dependiendo de hogar no de grupo origen
- charlar con otra obrera
- caminar errando por su casa
- seguir a warrior para cambio de grupo, si no hay quien la proteja, ni dejar la base sola
- enviar robot a recolectar lejos

## Warrior

- caminar errando por su casa
- atacar con mele a enemigo cercano
- atacar a distancia a enemigo cercano
- lanzar explosivos a enemigos cercanos
- atacar con dron a enemigo lejano
- explorar libremente el mundo
- ir masivamente a atacar a punto
- conquistar obrera para llevarla a su grupo, prioridad mismo origen sobre otras (rescate)
- asociarse a grupo si no tiene el suyo (viaje tiempo)
- volver a casa por munición de distancia, explosivo, curacion o dron
- huir si superado en número al atacar

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

# Colisiones

- 0: layer 1, orilla del mar
- 1: layer 2, edificaciones: bases + casas
- 2: layer 3, naturales: arboles, rocas
- 3: layer 4, entes móviles, como humanos, player, animales, robots
- 4: layer 5, proyectiles

# Imágenes

- imagenes: escaneo 300pp PNG
- photoshop contraste +30
- photoshop desplazamiento -0.05
- - photoshop gamma +0.9
- photoshop intensidad +30
- escalado de imágenes 50%

# Comandos

- W,A,S,D: movimiento a pie
- Q,E: viaje temporal
- Lclic: disparar principal
- Rclic: disparo secundaria
- Mclic,R: recarga municion
- G: volverse neutral sin armas
- Z,X: recoger herramienta o arma
- Space: select / deselect compañeros viaje temporal
- Tab: ver dialogo de personaje
- Esc: pausa y salir
