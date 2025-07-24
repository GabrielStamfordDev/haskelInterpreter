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


Compiler questions LLVM IR

2.1 Como estão representadas as funções soma, multiplica e calcula em IR?

	Estão representadas essencialmente pela palavra-chave “define”, que indica o nome da função com o @, os parâmetros dentro dos parênteses e o corpo do método, sendo representado pelo início de um novo bloco básico, pelo “entry”. Por exemplo, a nível de simplicidade, considere a função:

int soma(int a, int b) {
    return a + b;
}

Em IR:

define dso_local i32 @soma(i32 %a, i32 %b) {
entry:
  %add = add nsw i32 %a, %b
  ret i32 %add
}

2.2 O que aparece no IR que representa a condição if (valor > 10)?

O valor > 10 está sendo representado pela linha   %cmp = icmp sgt i32 %valor, 10, com o icmp indicando uma comparação inteira e o sgt representado a comparação do tipo > (maior que = “greater than(gt)”), ou seja, está checando se %valor é maior que o inteiro 10 e armazena a resposta em %cmp. Já o desvio condicional causado pelo if em que ser representado com a criação de um nova Branch, ao usar o br. Dessa maneira, no trecho de código br i1 %cmp, label %if.then, label %if.else temos que: checa-se a veracidade da condição booleana i1 %cmp, de tal forma que se for verdadeira, o código será direcionado para o label %if.then:

if.then:
  %call1 = call i32 @multiplica(i32 %valor, i32 2)
  br label %if.end

Entretanto, se for falsa, será direcionado para 

if.else:
  %call2 = call i32 @soma(i32 %valor, i32 5)
  br label %if.end

Por fim, como vimos em sala, pelo Grafo de Fluxo de Controle, a lógica do if else acaba convergindo. Nesse caso, sendo representado por
if.end:
  %resultado = phi i32 [ %call1, %if.then ], [ %call2, %if.else ]
  ret i32 %resultado
}
Que checa se ela foi chamada por if.then ou por if,else. Se foi pelo primeiro, armazena %call1 em %resultado e o análogo para o outro caso.

2.3 Como são representadas as chamadas às funções auxiliares em IR?

Essencialmente, pela palavra-chave “call”. Por exemplo,

  %call2 = call i32 @soma(i32 %valor, i32 5) 

Está chamando a função soma, que retorna um inteiro i32 e está passando como argumento os  inteiros %valor e 5 
