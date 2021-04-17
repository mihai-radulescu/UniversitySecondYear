maxshow :: (Ord x, Show y) => x -> x -> y -> y -> String
maxshow a b c d = 
    if a > b then show c
             else show d

data Lista a = Gol | a ::: (Lista a) deriving(Eq, Ord, Read)

instance Show a => Show (Lista a) where
    show Gol = "[]"
    show (head ::: tail) = show head ++ ":" ++ show tail

data Special a = S1 | S2 deriving(Eq, Show)

data Nested a = S (Special a) | I Int deriving(Eq, Show, Ord)

instance Ord (Special a) where 
    x <= y = False

-- Functor, Applicative, Monad
-- (a -> b) -> [] a -> [] b

data Arbore a = Leaf | Nod (Arbore a) a (Arbore a)

instance Show a => Show (Arbore a) where 
    show Leaf = "frunza"
    show (Nod left x right) = "(" ++ show left ++ ") < " ++ show x ++ " > (" ++ show right ++ ")"

instance Functor Arbore where 
    fmap f Leaf = Leaf 
    fmap f (Nod left x right) = Nod (fmap f left) (f x) (fmap f right)

instance Foldable Arbore where 
    foldr _ accum Leaf = accum
    foldr f accum (Nod left x right) = 
        let dreapta = foldr f accum right in 
        let next = f x dreapta in 
        foldr f next left

instance Semigroup Int where 
    x <> y = x + y

instance Monoid Int where 
    mempty = 0

aplica lista_f lista_e = [f x | f <- lista_f, x <- lista_e]
aplica' lista_f lista_e = do
    f <- lista_f 
    x <- lista_e 
    return (f x)

fmap' f cutie = 
    let f' = pure f in 
    f' <*> cutie

divisori n = [x | x <- [1..n], mod n x == 0]

hd [] = Nothing 
hd (h:_) = Just h 

invers 0 = Nothing 
invers x = Just (1.0 / x)

divisori2 cutie = do
    x <- cutie 
    y <- divisori x 
    return y

-- instance Monad [] where 
    -- return x = [x]
    -- [] >>= f = []
    -- (h:t) >>= f = f h ++ (t >>= f)
