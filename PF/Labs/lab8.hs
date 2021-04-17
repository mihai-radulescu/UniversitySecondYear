data MyList a = Nil | a ::: (MyList a) 

instance Show a => Show (MyList a) where 
    show Nil = "[]"
    show (head:::Nil) = show head ++ "]"
    show (head:::tail) = show head ++ "," ++ show tail

-- instance Functor [] where 
--     fmap = map 
instance Functor MyList where 
    fmap _ Nil = Nil
    fmap f (head ::: tail) = (f head) ::: (fmap f tail)

instance Foldable MyList where 
    foldr _ accum Nil = accum 
    foldr f accum (head ::: tail) = 
        let x = foldr f accum tail in 
        f head x

data MyPair a b = P a b

divisori x = [y | y <- [1..x], x `mod` y == 0]

head' [] = Nothing
head' (h:_) = Just h 

inverse 0 = Nothing 
inverse x = Just (1.0 / x)

concatenat Nil x = x
concatenat (h:::t) x = h:::(concatenat t x)

instance Applicative MyList where 
    pure x = x ::: Nil 
    Nil <*> _ = Nil 
    (head_functie ::: tail_functie) <*> lista = fmap head_functie lista `concatenat` (tail_functie <*> lista)

instance Monad MyList where 
    return = pure 
    Nil >>= _ = Nil 
    (h ::: t) >>= f = 
        f h `concatenat` (t >>= f)

-- Aveti (>>=) implementat 
-- Cu ajutorul lui implementati <*> (starship???)
--
primul_divisor x = return ((divisori x) !! 1)

sum' a b = do
    x <- a
    y <- b
    return (x + y)

sum'' cutie = [x + y | x <- cutie, y <- cutie]

scoate cutie = do 
    x <- cutie 
    y <- x 
    return y

scoate' cutie = do 
    x <- cutie 
    x

scoate'' cutie = cutie >>= (\x -> x)

data Promise a = Waiting | Done a

instance Functor Promise where 
    fmap = undefined 

instance Applicative Promise where 
    a <*> b = undefined 
    pure = undefined 

instance Monad Promise where 
    a >>= b = undefined 

type Id = Int 
type Money = Int 

get_id_by_username :: String -> Promise Id 
get_id_by_username = undefined 

get_money :: id -> Promise Money 
get_money = undefined 

find_money :: String -> Promise Money 
find_money username = do 
    id <- get_id_by_username username 
    money <- get_money id 
    return money 
    -- get_money id 

main = do 
    name <- getLine
    putStrLn ("Hello World: " ++ name)i

bind :: (Monad m) => m a -> (a -> m b) -> m b 
-- ^^ il aveti 

starship :: (Monad m) => m (a -> b) -> m a -> m b
starship = (<*>)
-- trebe implementat
