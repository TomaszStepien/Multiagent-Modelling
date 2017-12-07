# prace domowe
1) sudoku
2) gazeciarz
3) torus
4) tsp
5) schelling


# virus 1.0 
- agent z 2 atrybutami
  - location: krotka - współrzędne x i y 
  - sick: integer - 1 gdy zdrowy, 2 gdy chory

- agenci poruszają sie losowo o jedno pole w każdej iteracji w poziomie, w pionie lub na ukos
- agenci zarażają się gdy w sąsiedztwie (Moore) znajdzie się przynajmniej jeden chory i pozostają chorzy do końca
