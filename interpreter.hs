type Id = String
type Numero = Double
data TermoLinFun = Identifier Id
                 | Literal Numero
                 | Lambda Id TermoLinFun
                 | Aplicacao TermoLinFun TermoLinFun
data Definicao = Def Id TermoLinFun
type Programa = [Definicao]

def4 = Def "soma" (Lambda "x"( Lambda "y" (Aplicacao( Aplicacao(Identifier "+") (Identifier "x")) (Identifier "y"))))
def5 = Def "v" (Aplicacao (Aplicacao (Identifier "+") (Literal 5 ))(Literal 10 ))
def6 = Def "resultado" (Aplicacao (Aplicacao (Identifier "soma") (Identifier "v")) (Literal 20))

prog2 = [def4, def5, def6]

instance Show TermoLinFun where
    show (Identifier id)   = id
    show (Literal n)       = show n
    show (Lambda id t)     = "\\" ++ id ++ " -> " ++ (show t)
    show (Aplicacao t1 t2) = "(" ++ (show t1) ++ " " ++ (show t2) ++ ")"

instance Show Definicao where
    show (Def id t) = id ++ " = " ++ show t ++ "\n"
