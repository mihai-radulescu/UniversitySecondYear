-- http://www.inf.ed.ac.uk/teaching/courses/inf1/fp/



import Data.Char
import Data.List


-- 1.
rotate :: Int -> [Char] -> [Char]
rotate x key = 
    if x > length key then
        error "Nu-mi place parametrul"
    else 
        let newn = take x key in 
        (drop x key) ++ newn

-- 2.
prop_rotate :: Int -> String -> Bool
prop_rotate k str = rotate (l - m) (rotate m str) == str
                        where l = length str
                              m = if l == 0 then 0 else k `mod` l

-- 3.
makeKey :: Int -> [(Char, Char)]
makeKey n = 
    zip ['A'..'Z'] (rotate n ['A'..'Z'])

-- 4.
lookUp :: Char -> [(Char, Char)] -> Char
lookUp c lista = 
    let l2 = [y | (x, y) <- lista, x == c] in 
    if l2 == [] then 
        c 
    else 
        head l2 

lookUp' c lista = 
    head [y | (x, y) <- (lista ++ [(c, c)]), x == c]

-- 5.
encipher :: Int -> Char -> Char
encipher n c = lookUp c (makeKey n)

-- 6.
normalize :: String -> String
normalize string = 
    let s2 = filter isAlphaNum string in 
    map toUpper s2 

-- 7.
encipherStr :: Int -> String -> String
encipherStr n str = [encipher n x | x <- normalize str]

-- 8.
reverseKey :: [(Char, Char)] -> [(Char, Char)]
reverseKey cheie = [(y, x) | (x, y) <- cheie]

-- 9.
decipher :: Int -> Char -> Char
decipher n c = let key = reverseKey (makeKey n) in 
    lookUp' c key

decipherStr :: Int -> String -> String
decipherStr n str = 
    [decipher n x | x <- str]


prop_cipher n string =
    let m = n `mod` 26 in 
    let s = normalize string in 
    decipherStr m (encipherStr m s) == s

a = (2, "Salut") :: (Int, String)
b = (2, "Salut") :: (,) Int String
c = (,) 2 "Salut" :: (,) Int String
--  ^^
--  data constructor  ^^
--                    type constructor

type RasaDePisic = String

data Linie a = L [a]
data Matrice a = M [Linie a]

m = (M [L [1, 2, 3], L [4, 5], L [2, 3, 6, 8], L[8, 5, 3]])

instance Show a => Show (Linie a) where 
    show (L []) = ""
    show (L [x]) = show x
    show (L (h:t)) = (show h) ++ " " ++ (show (L t))

instance Show a => Show (Matrice a) where 
    show (M []) = ""
    show (M [l]) = show l
    show (M (h:t)) = (show h) ++ "\n" ++ (show (M t))

map' f lista = foldr (\x accum -> (f x):accum) [] lista 
filter' f lista = foldr (\x accum -> if f x then x:accum else accum) [] lista

verifica :: Matrice Int -> Int -> Bool
verifica (M linii) n = 
    let aux (L inturile) = foldr (+) 0 inturile in 
    let l2 = map' aux linii in 
    (filter' (/=n) l2) == []

verifica' (M linii) n = 
    let l2 = foldr (\(L inturile) accum -> (foldr (+) 0 inturile):accum) [] linii in 
    (filter' (/=n) l2) == []

map'' f [] = []
map'' f (h:t) = (f h):(map'' f t)

filter'' f [] = []
filter'' f (h:t) = if f h then h:(filter'' f t) else (filter'' f t)

max3 :: Ord a => a -> a -> a -> a
max3 a b c = max (max a b) c

data MyError = Bun | Eroare String deriving (Show)
all_equal :: (Eq a, Show a) => [a] -> MyError
all_equal [] = Bun
all_equal [x] = Bun
all_equal (h1:h2:t) = if h1 == h2 then all_equal (h2:t) else Eroare (show h1 ++ " vs " ++ show h2)
