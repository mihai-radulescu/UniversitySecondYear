import Test.QuickCheck

double :: Int -> Int
double x = 2 * x
triple :: Int -> Int
triple y = 3 * y
penta :: Int -> Int
penta x = 5 * x

test x = (double x + triple x) == (penta x)
test_double x = (double x) == x + x

binom a b = a^2 + 2 * a * b + b^2
test_binom a b = (binom a b) == (a +b)^2

myLookUp :: Int -> [(Int,String)]-> Maybe String
myLookUp x ((key, value):t) = if x == key then Just value else myLookUp x t
myLookUp _ [] = Nothing

myLookUp' x lista = 
    let l = [value | (key, value) <- lista, key == x] in 
    if l == [] then Nothing else Just (head l) -- Just (l !! 0)

test_chior x = (lookup x [(x, 2)] == Just 2)
testLookUp :: Int -> [(Int,String)] -> Bool
testLookUp x lista =
    (lookup x lista) == (myLookUp' x lista)

testLookUp' x lista = (length lista > 4) ==> testLookUp x lista 

-- testLookUpCond :: Int -> [(Int,String)] -> Property
-- testLookUpCond n list = n > 0 && n `div` 5 == 0 ==> testLookUp n list

data ElemIS = I Int | S String
     deriving (Show,Eq)

instance Arbitrary ElemIS where 
    arbitrary = elements [I 5, S "Salut", S "Hello World", I 0]

myLookUpElem :: Int -> [(Int,ElemIS)]-> Maybe ElemIS
myLookUpElem = lookup

testLookUpElem :: Int -> [(Int,ElemIS)] -> Bool
testLookUpElem elem lista = (myLookUpElem elem lista) == (lookup elem lista)

data F a b = F1 a | F2 b
