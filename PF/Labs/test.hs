data Point = P Integer Integer deriving Show

data Geom = Geom [Point] deriving Show

check (P x y) = x > 0 && y > 0
vPozitive (Geom []) = Geom []
vPozitive (Geom (h:t)) = 
    let Geom restul = vPozitive (Geom t) in 
    if check h then Geom (h:restul)
               else Geom restul

vPozitive' (Geom lista) = Geom [x| x <- lista, check x]
vPozitive'' (Geom lista) = Geom (filter check lista)

figPozitive lista_figuri = 
    filter (\(Geom figura) -> let Geom aux = vPozitive (Geom figura) in length figura == length aux) lista_figuri

dist :: Point -> Point -> Float
dist (P x1 y1) (P x2 y2) = sqrt (fromIntegral ((x1 - x2)^2 + (y1 - y2)^2))

sumaDist (Geom figura1) (Geom figura2) =
    if length figura1 /= length figura2 
        then error "Numar de varfuri diferit!"
        else
            let f = zip figura1 figura2 in 
            foldr (\(a, b) accum -> (dist a b) + accum) 0 f

class GeomList a where 
    toListG :: a -> [(Integer, Integer)]
    fromListG :: [(Integer, Integer)] -> a

instance GeomList Geom where 
    toListG (Geom lista) = [(x, y) | P x y <- lista]
    fromListG lista = Geom [P x y | (x, y) <- lista]

conditie lista = 
    toListG ((fromListG lista) :: Geom) == lista
