--Jugadores de fútbol, de la forma (Nombre, Club, Puesto, Cotización)

-- Participantes, de la forma (Nombre, Jugadores)
participantes = 
  [("Natalia", ["Abbondazieri","Lluy","Battaglia", "Lazzaro"]),
   ("Romina",  ["Islas", "Lluy", "Battaglia", "Lazzaro"]),
   ("Jessica", ["Islas"])
  ]

-- Clubes de fútbol
clubes = ["Boca", "Racing", "Tigre"]
jugadores = [ ("Abbondazieri", "Boca", "Arquero", 6500000),
              ("Islas", "Tigre", "Arquero", 5500000),
              ("Lluy", "Racing", "Defensor", 1800000),
              ("Battaglia", "Boca", "Volante", 8000000),
              ("Lazzaro", "Tigre", "Delantero", 5200000)
            ]
-- Fechas del torneo que se han jugado
fechas = [ quinta, sexta, septima, octava ]

-- De cada una de las fechas jugadas,
-- de cada jugador participante se conoce su
-- evaluación en la forma (Nombre, PuntosLogrados, MinutosJugados) 

quinta 	= [("Lluy", 8, 90), ("Lazzaro", 6, 90)]
sexta 	= [("Lazzaro", 7, 77), ("Islas", 6, 90), ("Lluy", 7, 90)]
septima	= [("Battaglia", 13, 90), ("Lluy", 6, 90), ("Lazzaro", 8, 77)]
octava 	= [("Islas", 4, 84), ("Battaglia", 8, 90)]

-- Funciones Auxiliares
nombre (nombre,_,_,_) = nombre
club (_,club,_,_) = club
puesto (_,_,puesto,_) = puesto
cotizacion (_,_,_,cotizacion) = cotizacion
equipoDe participante = (snd . head) $ filter ((==participante) . fst) participantes
-- 1. cotizacionDe
cotizacionDe :: String -> Integer
cotizacionDe jugador = (cotizacion . head) $ filter ((==jugador) . nombre) jugadores
cotizacionDe' jugador = head [cotizacion  x | x <- jugadores, ((==jugador).nombre) x]

-- 2. cotizacionEquipoDe
cotizacionEquipoDe :: String -> Integer
cotizacionEquipoDe participante = sum $ map cotizacionDe (equipoDe participante)

-- 3. fueUsadoPor
fueUsadoPor :: String -> String -> Bool
fueUsadoPor jugador participante = elem jugador (equipoDe participante)

-- 4. nombreJugadoresClub
nombresJugadoresClub :: String -> [String]
nombresJugadoresClub clubElegido = [nombre x | x <- jugadores,club x == clubElegido]

-- 5. nombresTodoslosJugadores
nombresTodoslosJugadores :: [String]
nombresTodoslosJugadores = map nombre jugadores

type Evaluacion = (String,Integer,Integer)
type Fecha = [Evaluacion]

nombreJug (nombre,_,_) = nombre
puntos (_,puntos,_) = puntos
minutos (_,_,minutos) = minutos
jugadoresFecha :: Fecha -> [String]
jugadoresFecha fecha = map nombreJug fecha

-- 6. jugoFechaJugador
jugoFechaJugador :: Fecha -> String -> Bool
jugoFechaJugador fecha jugador  = elem jugador (jugadoresFecha fecha)

-- 7. minutosFechaJugador
minutosFechaJugador :: Fecha -> String -> Integer
minutosFechaJugador fecha jugador
  | jugoFechaJugador fecha jugador = sum [minutos x |x <- fecha, nombreJug x == jugador]
  | otherwise = 0
evaluacion jugador fecha = [ x | x <- fecha, nombreJug x == jugador]
jugadasTorneo jugador = eliminarVacios $ map (evaluacion jugador) fechas
eliminarVacios lista = map head [x | x <- lista, x /= []]

-- 8. totalPuntosJugador
totalPuntosJugador :: String -> Integer
totalPuntosJugador jugador = sum $ map puntos (jugadasTorneo jugador)

cantidadJugadasTorneo  = length . jugadasTorneo
-- 9. promedioPuntosJugador
promedioPuntosJugador :: String -> Float
promedioPuntosJugador jugador = fromIntegral (totalPuntosJugador jugador) / fromIntegral (cantidadJugadasTorneo jugador)

maximo [] = ("", 0)
maximo (x:xs)
  | snd x > snd (maximo xs) = x
  | otherwise = maximo xs
-- criterios

-- 10. mejorJugadorPor
mejorJugadorPor criterio = fst(maximo (map (aplicarCriterio criterio) nombresTodoslosJugadores))

aplicarCriterio criterio jugador = (jugador, criterio jugador)

-- 11. equipoValido
equipoValido :: [String] -> Bool
equipoValido lista = cotizacionEquipo lista < 60000000 && length lista == 11 
cotizacionEquipo lista = sum (map cotizacionDe lista)

-- 12. nombresDeParticipantes
nombresDeParticipantes :: [String]
nombresDeParticipantes = map fst participantes

-- 13.
nombresJugadoresDeValorMenorADelPuesto importe puestoE = [nombre x | x <- jugadores, cotizacion x <= importe && puesto x ==puestoE ]

