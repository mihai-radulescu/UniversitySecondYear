import           Prelude hiding (lookup)
import qualified Data.List as List

data Persoana = P String String Int Int Int  deriving (Show)
data Persoana' = P' { nume :: String
                    , prenume :: String
                    , varsta :: Int
                    , experienta :: Int
                    , copii :: Int } deriving (Show)

oldest people = 
    let simplu = [ (v, n) | (P' { nume=n, varsta=v }) <- people ] in 
    let (_, cine) = maximum simplu in 
    cine 

class Collection c where
  empty :: c key value

  singleton :: key -> value -> c key value

  insert
      :: Ord key
      => key -> value -> c key value -> c key value
  lookup :: Ord key => key -> c key value -> Maybe value
  delete :: Ord key => key -> c key value -> c key value

  keys :: c key value -> [key]
  keys container = [x | (x, _) <- toList container]

  values :: c key value -> [value]
  values container = [y | (_, y) <- toList container]

  toList :: c key value -> [(key, value)]
  toList container = zip (keys container) (values container)

  fromList :: Ord key => [(key,value)] -> c key value
  fromList lista = 
    let aux container l = case l of 
            [] -> container 
            ((key, value):tail) -> aux (insert key value container) tail 
    in 
    aux empty lista 

newtype PairList k v
  = PairList { getPairList :: [(k, v)] }

instance Collection PairList where 
    empty = PairList { getPairList = [] }

    singleton key value = PairList { getPairList = [(key, value)] }

    insert key value (PairList { getPairList=container }) =
        PairList { getPairList=(key, value):container }

    lookup key (PairList { getPairList=[] }) = Nothing 
    lookup key (PairList { getPairList=((k, v):tail) }) =
        if k == key then 
            Just v 
        else 
            lookup key (PairList { getPairList=tail })

    delete key (PairList { getPairList=[] }) = PairList { getPairList=[] }
    delete key (PairList { getPairList=((k, v):tail) }) = 
        if k == key then 
            delete key (PairList { getPairList = tail })
        else 
            let PairList { getPairList=restul} = delete key (PairList {getPairList = tail }) in
            PairList { getPairList=((k, v):restul) }

    toList (PairList { getPairList=lista }) = lista 

data SearchTree key value
  = Empty
  | Node
      (SearchTree key value) -- elemente cu cheia mai mica 
      key                    -- cheia elementului
      (Maybe value)          -- valoarea elementului
      (SearchTree key value) -- elemente cu cheia mai mare

instance Collection SearchTree where 
    empty = Empty 
    singleton key value = Node Empty key (Just value) Empty 

    insert key value Empty = singleton key value 
    insert key value (Node left k v right) = 
        if k == key then 
            Node left k (Just value) right 
        else if k < key then 
            Node (insert key value left) k v right 
        else 
            Node left k v (insert key value right)

    lookup _ Empty = Nothing 
    lookup key (Node left k v right) = 
        if k == key then v 
        else if k < key then 
            lookup key left 
        else 
            lookup key right 

    delete _ Empty = Empty 
    delete key (Node left k v right) = 
        if k == key then Node left k Nothing right 
        else if k < key then 
            Node (delete key left) k v right 
        else 
            Node left k v (delete key right)

    toList Empty = []
    toList (Node left k Nothing right) = (toList left) ++ (toList right)
    toList (Node left k (Just v) right) = (toList left) ++ [(k, v)] ++ (toList right)

order = 1

data Element k v
  = Element k (Maybe v)
  | OverLimit

data BTree key value
  = BEmpty
  | BNode [(BTree key value, Element key value)]

