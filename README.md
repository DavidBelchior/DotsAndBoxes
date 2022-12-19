# Projeto Nº 1: Época Normal
![image](https://user-images.githubusercontent.com/76535435/208324726-69dc1bec-cdeb-4446-b659-0055c1ddd4bc.png)
## Inteligência Artificial 22/23
### Prof. Joaquim Filipe
### Eng. Filipe Mariano

# Dots and Boxes
## Manual Técnico
#### Realizado por:
#### André Matias - 202000941
#### David Belchior - 202001670
#### 21 de Dezembro de 2022

## Indice
* Introdução
* Arquitetura do Sistema
* Entidades e sua implementação
* Algoritmos e sua implementação
* Resultados
* Limitações técnicas e ideias para desenvolvimento futuro

## Introdução
Este documento corresponde ao manual técnico do projeto Dots and Boxes que é um jogo para dois jogadores. Foi publicado pela primeira vez no século 19 pelo matemático francês Édouard Lucas, que o chamou de la pipopipette.

No âmbito da unidade curricular de Inteligência Artificial, foi proposto o projecto do jogo “Dots and Boxes”, no qual este é um jogo constituído por um tabuleiro de n * m caixas (n linhas de caixas e m colunas de caixas). Cada caixa é delimitada por 4 pontos entre os quais é possível desenhar um arco. Quando os quatro pontos à volta de uma caixa tiverem conectados por 4 arcos, a caixa é considerada fechada. O espaço da solução é portanto constituído por n * m caixas, (n + 1) * (m + 1) pontos e (m * (n + 1)) + (n * (m + 1)) arcos.

O jogo inicia com um tabuleiro vazio em que os jogadores alternadamente vão colocando um arco horizontal ou vertical. Quando o arco colocado por um jogador fecha uma caixa, essa caixa conta como 1 ponto para o jogador que colocou o arco e esse jogador deve jogar novamente.

O jogo termina quando todas as caixas tiverem fechadas, ou seja, não existirem mais arcos para colocar, ganhando o jogador que fechou mais caixas.

O objectivo deste projeto é resolver todos os problemas descritos no anexo do enunciado de A) a F). A resolução dos problemas mencionados será implementada na linguagem de programação funcional Common Lisp, utilizando toda a matéria lecionada na unidade curricular até ao momento, a fim de tentar fornecer uma solução apropriada para cada um dos problemas apresentados.

Neste documento serão descritas detalhadamente todas as metricas de desenvolvimento usadas e funções implementadas.

## Arquitetura do Sistema

O Jogo foi implementado em linguagem LISP, utilizando o IDE LispWorks. A estrutura do projeto é composta por 4 ficheiros:

- projeto.lisp - Carrega os outros ficheiros de código, escreve e lê ficheiros, e trata da interação com o utilizador.

- puzzle.lisp -  Código relacionado com o problema.

- procura.lisp - Contém implementação de:

  * Algoritmo de Procura de Largura Primeiro (BFS)
  * Algoritmo de Procura do Profundidade Primeiro (DFS)
  * Algoritmo de Procura do Melhor Primeiro (A*)
  * Os algoritmos SMA*, IDA* e/ou RBFS (caso optem por implementar o bónus)
  
- problemas.dat - Funções com os problemas de A) a F).

- solucao.dat - Que é o output descrito para cada um dos problemas solucionados com os algoritmos identificados que conterá:

  * A solução encontrada 
  
  * E dados estatísticos sobre a sua eficiência, nomeadamente:
    - O fator de ramificação média
    - O número de nós gerados
    - O número de nós expandidos
    - A penetrância
    - O tempo de execução
    - E o caminho até à solução
    
## Entidades e sua implementação

### Tabuleiro
    
O tabuleiro consiste numa apresentação sob a forma de uma lista de listas em LISP, composta por atomos, em que cada atomo representa uma casa com um valor numérico,o tabuleiro é representado por n linhas de m colunas. A primeira lista corresponde a todos os arcos horizontais e a segunda corresponde a todos os arcos verticais.

Temos assim ao todo 6 problemas que são os tabuleiros de A) a F) apresentados no ficheiro problemas.dat.

Como exemplo de um Estado Inicial para uma melhor compreensão do anteriormente descrito será de seguida apresentado o Problema a):









