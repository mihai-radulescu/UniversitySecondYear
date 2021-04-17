import           Test.QuickCheck hiding (Failure, Success)

semigroupAssoc :: (Eq m, Semigroup m) => m -> m -> m -> Bool
semigroupAssoc a b c = (a <> (b <> c)) == ((a <> b) <> c)

monoidLeftIdentity   :: (Eq m, Monoid m) => m -> Bool
monoidLeftIdentity a = (mempty <> a) == a

monoidRightIdentity   :: (Eq m, Monoid m) => m -> Bool
monoidRightIdentity a = (a <> mempty) == a

-- Example 1 - Trivial
 
data Trivial = Trivial
  deriving (Eq, Show)

instance Semigroup Trivial where
  _ <> _ = Trivial

instance Monoid Trivial where
  mempty  = Trivial

instance Arbitrary Trivial where
  arbitrary = return Trivial

type TrivAssoc = Trivial -> Trivial -> Trivial -> Bool
type TrivId    = Trivial -> Bool

testTrivial :: IO ()
testTrivial
  = do
    quickCheck (semigroupAssoc :: TrivAssoc)
    quickCheck (monoidLeftIdentity :: TrivId)
    quickCheck (monoidRightIdentity :: TrivId)

-- Exercise 2 - Identity
 
newtype Identity a = Identity a
  deriving (Eq, Show)

instance Semigroup a => Semigroup (Identity a) where
  Identity x <> Identity y = Identity (x <> y)

instance (Semigroup a, Monoid a) => Monoid (Identity a) where
  mempty = Identity mempty

instance Arbitrary a => Arbitrary (Identity a) where
  arbitrary = Identity <$> arbitrary
  -- arbitrary = fmap Identity (arbitrary :: Gen a)
testIdentity = do 
    quickCheck (semigroupAssoc :: (Identity [Int] -> Identity [Int] -> Identity [Int] -> Bool))
    quickCheck (monoidLeftIdentity :: (Identity [Int] -> Bool))
    quickCheck (monoidRightIdentity :: (Identity [Int] -> Bool))
-- Exercise 3 - Pair
 
data Two a b = Two a b
  deriving (Eq, Show)

instance (Semigroup a, Semigroup b) => Semigroup (Two a b) where
    (Two a b) <> (Two c d) = Two (a <> c) (b <> d)

instance (Monoid a, Monoid b) => Monoid (Two a b) where
    mempty = Two mempty mempty

instance (Arbitrary a, Arbitrary b) => Arbitrary (Two a b) where
  --arbitrary = Two <$> arbitrary <*> arbitrary
  --arbitrary = (pure Two) <*> arbitrary <*> arbitrary
  arbitrary = do 
    x <- arbitrary
    y <- arbitrary
    return (Two x y)

simple_false :: Two Int String -> Bool
simple_false x = False

-- Exercise 4 - Triple
 
data Three a b c = Three a b c
  deriving (Eq, Show)

instance ( Arbitrary a
         , Arbitrary b
         , Arbitrary c
         ) => Arbitrary (Three a b c) where
  arbitrary = Three <$> arbitrary <*> arbitrary <*> arbitrary

-- Exercise 5 - Boolean conjunction
 
newtype BoolConj = BoolConj Bool
  deriving (Eq, Show)

instance Arbitrary BoolConj where
  arbitrary = BoolConj <$> arbitrary

instance Semigroup BoolConj where 
   (BoolConj True) <> (BoolConj True) = BoolConj True
   _ <> _ = BoolConj False

instance Monoid BoolConj where 
    mempty = BoolConj True 

-- Exercise 6 - Boolean disjunction
 
newtype BoolDisj = BoolDisj Bool
  deriving (Eq, Show)

instance Arbitrary BoolDisj where
  arbitrary = BoolDisj <$> arbitrary

instance Semigroup BoolDisj where 
   (BoolDisj False) <> (BoolDisj False) = BoolDisj False
   _ <> _ = BoolDisj True

instance Monoid BoolDisj where 
    mempty = BoolDisj False 


-- Exercise 7 - Or
 
data Or a b = Fst a | Snd b
  deriving (Eq, Show)

instance Semigroup (Or a b) where 
    Snd err <> _ = Snd err 
    _ <> x = x

instance Monoid (Or a b) where 
    mempty = Fst undefined

instance (Arbitrary a, Arbitrary b) => Arbitrary (Or a b) where
  arbitrary = oneof [Fst <$> arbitrary, Snd <$> arbitrary]

-- Exercise 8 - Lifting Monoid to Functions
data Person = Person { getName :: String
                     , getAge :: Int } deriving (Show)

newtype Sum a = Sum { unSum :: a } deriving (Show)

instance Num a => Semigroup (Sum a) where
    (Sum a) <> (Sum b) = Sum (a + b)

instance Num a => Monoid (Sum a) where 
    mempty = Sum 0

newtype Combine a b = Combine { unCombine :: a -> b }

instance (Semigroup b) => Semigroup (Combine a b) where 
    (Combine f) <> (Combine g) = Combine (\x -> f x <> g x)

instance (Monoid b) => Monoid (Combine a b) where 
    mempty = Combine (\_ -> mempty)

instance (CoArbitrary a, Arbitrary b) => Arbitrary (Combine a b) where
  arbitrary = Combine <$> arbitrary

f = Combine (\n -> Sum (n + 1))
g = Combine (\n -> Sum (n - 1))

newtype Prod a = Prod { getProd :: a } deriving (Show)

instance Num a => Semigroup (Prod a) where 
    (Prod a) <> (Prod b) = Prod (a * b)

instance Num a => Monoid (Prod a) where 
    mempty = Prod 1

h = Combine (\n -> Prod (n `div` 2))
i = Combine (\n -> Prod (n * 3)) 

newtype Reader a = { readElem :: IO a }
