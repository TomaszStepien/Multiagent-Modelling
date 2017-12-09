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

# virus 1.1
- agent z 3 atrybutami
  - location: krotka - współrzędne x i y 
  - sick: integer - 1 gdy zdrowy, 2 gdy chory
  - immunity: float - z przedziału (0, 1), odporność im wyższa tym lepsza
  
- agenci poruszają sie losowo o jedno pole w każdej iteracji w poziomie, w pionie lub na ukos
- agenci zarażają się gdy spełniony jest warunek agent.sick == 1 && sick_neighbours/8 >= agent.immunity i pozostają chorzy do końca

# virus 1.2
- agent z 4 atrybutami
  - location: krotka - współrzędne x i y 
  - sick: integer - 1 gdy zdrowy, 2 gdy chory
  - immunity: float - z przedziału (0, 1), odporność im wyższa tym lepsza
  - vaccinated: boolean - 0 gdy nieszczepiony, 1 gdy szczepiony
  
- agenci poruszają sie losowo o jedno pole w każdej iteracji w poziomie, w pionie lub na ukos
- agenci zarażają się gdy jest spełniony warunek (sick_neighbours/8)*(1 - agent.immunity)*(1-agent.vaccinated*0.3) > rand(Float64)
- agenci zostają chorzy do końca 

# virus 1.3
- agent z 5 atrybutami
  - location: krotka - współrzędne x i y 
  - sick: integer - 1 gdy zdrowy, 2 gdy chory
  - immunity: float - z przedziału (0, 1), odporność im wyższa tym lepsza
  - vaccinated: boolean - 0 gdy nieszczepiony, 1 gdy szczepiony
  - generation: Integer - generacja wirusa, 1 na starcie. Gdy wirus zmutuje podczas zarażania, generacja rośnie o 1. Im wyższa generacja     tym mniejsza skuteczność szczepionki 
  
- agenci poruszają sie losowo o jedno pole w każdej iteracji w poziomie, w pionie lub na ukos
- agenci zarażają się gdy jest spełniony warunek:
  (sick_neighbours/8)*(1 - agent.immunity)*(1 - agent.vaccinated*0.3*(1/agent.generation)) > rand(Float64)
- agenci zostają chorzy do końca

# virus 1.4
- agent z 7 atrybutami
  - location: krotka - współrzędne x i y 
  - sick: integer - 1 gdy zdrowy, 2 gdy chory
  - immunity: float - z przedziału (0, 1), odporność im wyższa tym lepsza
  - vaccinated: boolean - 0 gdy nieszczepiony, 1 gdy szczepiony
  - generation: Integer - generacja wirusa, 1 na starcie. Gdy wirus zmutuje podczas zarażania, generacja rośnie o 1. Im wyższa generacja     tym mniejsza skuteczność szczepionki 
  - days_sick: Integer - ile dni byli chorzy
  - was_sick: Boolean - czy byli chorzy
  
- agenci poruszają sie losowo o jedno pole w każdej iteracji w poziomie, w pionie lub na ukos
- agenci zarażają się gdy jest spełniony warunek:
  (sick_neighbours/8)*(1 - agent.immunity)*(1 - agent.vaccinated*0.3*(1/agent.generation)) > rand(Float64)
- agenci nie zostają chorzy do końca. Zdrowieją po określonej liczbie dni. Szczepionki skracają chorobę :) Agent który był chory nie       może się już zarazić  

# virus 1.5
- agent z 8 atrybutami
  - location: krotka - współrzędne x i y 
  - sick: integer - 1 gdy zdrowy, 2 gdy chory
  - immunity: float - z przedziału (0, 1), odporność im wyższa tym lepsza
  - vaccinated: boolean - 0 gdy nieszczepiony, 1 gdy szczepiony
  - generation: Integer - generacja wirusa, 1 na starcie. Gdy wirus zmutuje podczas zarażania, generacja rośnie o 1. Im wyższa generacja     tym mniejsza skuteczność szczepionki 
  - days_sick: Integer - ile dni byli chorzy
  - was_sick: Boolean - czy byli chorzy
  - duration: Integer - ile dni trwa u tego agenta choroba 
  
- agenci poruszają sie losowo o jedno pole w każdej iteracji w poziomie, w pionie lub na ukos
- agenci zarażają się gdy jest spełniony warunek:
  (sick_neighbours/8)*(1 - agent.immunity)*(1 - agent.vaccinated*0.3*(1/agent.generation)) > rand(Float64)
- agenci nie zostają chorzy do końca. Zdrowieją po określonej liczbie dni. Szczepionki skracają chorobę :) Agent który był chory nie       może się już zarazić  

# virus 1.6
- agent z 7 atrybutami
  - location: krotka - współrzędne x i y 
  - sick: integer - 1 gdy zdrowy, > 1 gdy chory, mutacje zwiększają tę liczbę
  - immunity: float - z przedziału (0, 1), odporność im wyższa tym lepsza
  - vaccinated: boolean - 0 gdy nieszczepiony, 1 gdy szczepiony
  - days_sick: Integer - ile dni byli chorzy
  - was_sick: Boolean - czy byli chorzy
  - duration: Integer - ile dni trwa u tego agenta choroba 
  
- agenci poruszają sie losowo o jedno pole w każdej iteracji w poziomie, w pionie lub na ukos
- agenci zarażają się gdy jest spełniony warunek:
  (sick_neighbours/8)*(1 - agent.immunity)*(1 - agent.vaccinated*0.3*(1/agent.generation)) > rand(Float64)
  i przejmują generację wirusa od losowo wybranego zarażacza. Wirus może zmutować zwiększając generację o 1
- agenci nie zostają chorzy do końca. Zdrowieją po określonej liczbie dni. Szczepionki skracają chorobę :) Agent który był chory nie       może się już zarazić  

# możliwe ulepszenia modelu :P 
- szczepienia
- mutacje wirusa
- zasięg rozprzestrzeniania się wirusa
- inny sposób poruszania się agentów 
- pogoda
- rozne natezenie ruchu w roznych miejscach mapy
- zdrowienie agentow

# możliwe parametry do analizy w raporcie
- vaccination_power - o ile % szczepionka zmniejsza ryzyko zachorowania
- density - ile ludzi jest na mapie

# elementy raportu
1. Strona tytułowa: Zawiera nazwę organizacji, dla której budowany jest model, temat opracowania, sygnatura przedmiotu, nazwiska studentów, nr alb (w nawiasie zakres odpowiedzialności studenta: budowa modelu, an. wrażliwości, edycja raportu itp.).
2. Podsumowanie: Wskazanie głównych wyników (również liczbowych) i wniosków z raportu – propozycji rozwiązania problemu wraz z krótkim uzasadnieniem. W podsumowaniu powinno używać się łatwego słownictwa nie zawierającego żargonu technicznego.
3. Opis organizacji: Podsumowanie rodzaju działalności organizacji, rodzaj produktów/usług oferowanych klientom, wielkość organizacji, rodzaj rynku (monopol, doskonała konkurencja itp.), główni konkurenci.
4. Opis problemu, który ma być analizowany metodą symulacyjną : Opis powinien zawierać cele modelowania, niezbędne założenia i ograniczenia analizy.
5. Wyniki analizy : Liczby wraz z ich interpretacją. Czy rozwiązanie jest akceptowalne? Czy może być wdrożone w praktyce? Czy wynik jest zgodny z intuicją?
6. Analiza wrażliwości : Analiza skutków zmiany kluczowych parametrów lub uchylenia niektórych założeń analizy.
7. Wnioski i zalecenia : Jak wyniki analizy symulacyjnej mogą usprawnić działanie organizacji.
8. Bibliografia
