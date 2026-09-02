# 05 - Transakcje

## Po co są transakcje

Transakcja pozwala wykonać kilka operacji jako jedną całość.

Możesz:

- rozpocząć transakcję,
- wykonać zmiany,
- sprawdzić wynik,
- zatwierdzić zmiany przez `COMMIT`,
- albo cofnąć zmiany przez `ROLLBACK`.

Najprostsza intuicja:

```text
Transakcja to bezpieczne pudełko na zmiany.
```

Dopóki nie zrobisz `COMMIT`, możesz zdecydować, czy zmiany mają zostać zapisane,
czy cofnięte.

To jest szczególnie ważne przy DML, bo `INSERT`, `UPDATE` i `DELETE` zmieniają
dane w tabelach.

## Problem bez transakcji

Wyobraź sobie, że chcesz dodać nowe zamówienie.

Musisz wykonać kilka kroków:

1. dodać klienta,
2. dodać zamówienie,
3. dodać pozycje zamówienia.

Jeżeli pierwszy i drugi krok się uda, ale trzeci zakończy się błędem, baza może
zostać w dziwnym stanie:

```text
klient istnieje
zamówienie istnieje
pozycje zamówienia nie istnieją
```

Technicznie część danych została zapisana, ale biznesowo proces nie zakończył
się poprawnie.

Transakcja rozwiązuje ten problem:

```text
Jeżeli wszystkie kroki się udadzą -> COMMIT
Jeżeli którykolwiek krok się nie uda -> ROLLBACK
```

Dlatego transakcje są tak ważne przy pracy z powiązanymi tabelami.

## BEGIN

`BEGIN` rozpoczyna transakcję.

```sql
BEGIN;
```

## COMMIT

`COMMIT` zatwierdza zmiany.

```sql
COMMIT;
```

Po `COMMIT` zmiany zostają zapisane.

## ROLLBACK

`ROLLBACK` cofa zmiany wykonane w transakcji.

```sql
ROLLBACK;
```

Po `ROLLBACK` wracasz do stanu sprzed `BEGIN`.

## Przykład z ROLLBACK

```sql
BEGIN;

UPDATE course.orders
SET status = 'cancelled'
WHERE order_id = 1003;

SELECT *
FROM course.orders
WHERE order_id = 1003;

ROLLBACK;
```

Po `ROLLBACK` zmiana statusu zostanie cofnięta.

## Przykład z COMMIT

```sql
BEGIN;

UPDATE course.customers
SET acquisition_channel = 'referral'
WHERE customer_id = 8;

COMMIT;
```

Po `COMMIT` zmiana zostanie zapisana.

## Po co transakcje w praktyce

Transakcje są ważne, bo często jedna zmiana biznesowa wymaga kilku operacji.

Przykład:

- dodajesz klienta,
- dodajesz jego zamówienie,
- dodajesz pozycje tego zamówienia.

Jeśli część operacji się uda, a część nie, dane mogą zostać w niespójnym stanie.

Transakcja pozwala powiedzieć:

```text
Albo wszystko się uda, albo wszystko zostanie cofnięte.
```

## Transakcja jako jednostka pracy

W praktyce transakcja powinna obejmować jedną logiczną jednostkę pracy.

Przykłady:

- dodanie jednego zamówienia razem z pozycjami,
- aktualizacja statusu zamówienia i zapis powiązanej korekty,
- załadowanie jednej paczki danych do tabeli,
- usunięcie danych testowych z kilku tabel,
- odświeżenie tabeli roboczej.

Nie chodzi o to, żeby wrzucać całą pracę dnia do jednej wielkiej transakcji.

Chodzi o to, żeby razem zatwierdzać operacje, które logicznie muszą być spójne.

## Co transakcje dają data engineerowi

Data engineer często buduje procesy, które zapisują dane automatycznie.

Przykład:

```text
Pobierz dane z API.
Zapisz surowe rekordy.
Znormalizuj zamówienia.
Znormalizuj pozycje zamówień.
Załaduj dane do tabel.
```

Transakcja pomaga, gdy kilka zapisów do bazy powinno zakończyć się jako jedna
całość.

Dzięki transakcjom:

- nie zostawiamy częściowo załadowanych danych,
- łatwiej cofnąć nieudaną operację,
- można bezpieczniej testować `UPDATE` i `DELETE`,
- relacje między tabelami mają większą szansę zostać spójne,
- pipeline po błędzie nie zostawia bazy w przypadkowym stanie.

Przykład:

```text
orders załadowane
order_items niezaładowane
```

Taki stan jest podejrzany, bo zamówienia bez pozycji mogą zepsuć raporty.

Transakcja może sprawić, że albo obie tabele zostaną załadowane, albo żadna.

## ACID

Transakcje często opisuje się skrótem `ACID`.

```text
A - Atomicity
C - Consistency
I - Isolation
D - Durability
```

## Atomicity

Atomicity oznacza:

```text
Albo wykonuje się cała transakcja, albo żadna jej część.
```

Przykład:

- dodajemy zamówienie,
- dodajemy pozycje zamówienia.

Jeżeli zamówienie się dodało, ale pozycje już nie, dane są niespójne.

Transakcja pozwala cofnąć całość.

## Consistency

Consistency oznacza, że po transakcji baza nadal powinna spełniać swoje reguły.

Przykład:

- `PRIMARY KEY` nadal jest unikalny,
- `FOREIGN KEY` nadal wskazuje istniejące rekordy,
- `NOT NULL` nadal nie pozwala na braki w wymaganych kolumnach.

## Isolation

Isolation oznacza, że równoległe transakcje nie powinny sobie przypadkowo
przeszkadzać. W praktyce wiele osób albo procesów może jednocześnie pracować na bazie.

## Durability

Durability oznacza, że po `COMMIT` zmiany powinny być trwałe.

Jeżeli baza zatwierdziła transakcję, możesz mieć pewność, że dane są w bazie danych

## Autocommit

W wielu narzędziach SQL działa tryb `autocommit`.

Oznacza to, że pojedyncze polecenie może zostać zatwierdzone automatycznie.

Przykład:

```sql
UPDATE course.orders
SET status = 'paid'
WHERE order_id = 1003;
```
Jeżeli narzędzie ma włączony autocommit, zmiana może zostać zapisana od razu.


## Transakcja i błędy

Jeżeli w trakcie transakcji wystąpi błąd, trzeba świadomie zdecydować, co dalej.

Najczęściej przy nauce robimy:

```sql
ROLLBACK;
```

Czyli cofamy całą transakcję i zaczynamy od nowa.

Przykład:

```sql
BEGIN;

UPDATE course.orders
SET status = 'paid'
WHERE order_id = 1003;

-- tutaj wyobraź sobie, że kolejne query kończy się błędem

ROLLBACK;
```

Po `ROLLBACK` zmiana statusu zamówienia również zostanie cofnięta.

## Uwaga, używanie transakcji nie zwalnia z używania mózgu

Transakcja nie sprawi, że złe query stanie się dobre.

Jeżeli napiszesz:

```sql
BEGIN;

DELETE FROM course.order_items;

COMMIT;
```

to transakcja poprawnie zatwierdzi usunięcie wszystkich danych z tabeli.

## Transakcje a idempotencja

Transakcje i idempotencja to różne, ale powiązane pojęcia.

Transakcja odpowiada na pytanie:

```text
Czy kilka operacji zapisze się razem albo cofnie razem?
```

Idempotencja odpowiada na pytanie:

```text
Czy mogę uruchomić ten sam proces drugi raz bez duplikatów i uszkodzenia danych?
```

W pipeline'ach danych potrzebujemy często obu rzeczy.

Przykład:

- transakcja chroni przed częściowym zapisem,
- `ON CONFLICT DO UPDATE` chroni przed duplikatami przy ponownym uruchomieniu.

## Transakcje w data engineeringu

W pipeline'ach danych transakcje pomagają uniknąć częściowo załadowanych danych.

Przykład:

```text
Pipeline ładuje orders i order_items.
Orders się zapisały.
Order_items padły w połowie.
```

```text
Jeżeli cały load się nie udał, cofnij wszystko.
```

To jest ważne, bo dane po pipeline'ie powinny być spójne.
