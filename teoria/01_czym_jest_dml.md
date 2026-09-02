# 01 - Czym jest DML

## DML

DML oznacza `Data Manipulation Language`.

To część SQL, która służy do zmieniania danych w istniejących tabelach.

Najważniejsze polecenia DML:

- `INSERT` - dodaje nowe wiersze,
- `UPDATE` - zmienia istniejące wiersze,
- `DELETE` - usuwa wiersze.

## DQL vs DML

DQL, czyli `SELECT`, tylko odczytuje dane:

```sql
SELECT *
FROM course.customers;
```

DML zmienia dane:

```sql
UPDATE course.customers
SET email = 'anna.new@example.com'
WHERE customer_id = 1;
```

Pierwsze query tylko pokazuje dane. Drugie query faktycznie zmienia rekord w tabeli.

## DML z perspektywy data engineera

W aplikacjach DML często oznacza zwykłe operacje użytkownika:

- użytkownik zakłada konto,
- klient zmienia email,
- zamówienie zmienia status,
- rekord zostaje usunięty.

W data engineeringu DML pojawia się trochę inaczej. Data engineer używa go do:

- ładowania danych do tabel,
- poprawiania danych technicznych albo testowych,
- aktualizowania statusów przetwarzania,
- budowania powtarzalnych procesów ładowania,
- przygotowywania danych w tabelach roboczych,
- obsługi duplikatów przez `ON CONFLICT`.

Przykład:

```text
Pipeline pobiera dane z API -> przekształca je -> zapisuje do tabeli przez INSERT albo UPSERT.
```

Dlatego DML trzeba pisać ostrożnie. To nie jest już tylko pytanie do danych.
To jest operacja, która zostawia ślad w bazie.

## Dlaczego DML wymaga ostrożności

Błędny `SELECT` zwykle pokazuje zły wynik.

Błędny `UPDATE` albo `DELETE` może zmienić albo usunąć prawdziwe dane.

Dlatego przy DML pracujemy według schematu:

1. napisz `SELECT`,
2. sprawdź, które rekordy pasują do warunku,
3. wykonaj `INSERT`, `UPDATE` albo `DELETE`,
4. sprawdź wynik.

## Bezpieczny schemat pracy

Przy `UPDATE` i `DELETE` najważniejsza zasada brzmi:

> Najpierw napisz `SELECT` z takim samym `WHERE`.

Przykład:

```sql
SELECT *
FROM course.orders
WHERE status = 'pending';
```

Dopiero gdy wynik wygląda dobrze, zamieniamy początek zapytania na `UPDATE`
albo `DELETE`.

Przykład:

```sql
UPDATE course.orders
SET status = 'cancelled'
WHERE status = 'pending';
```

To pomaga uniknąć sytuacji, w której przypadkowo zmieniamy całą tabelę.

## DML i liczba zmienionych wierszy

Po operacji DML zawsze warto patrzeć, ile wierszy zostało zmienionych.

Jeżeli spodziewasz się zmienić jeden rekord, a baza mówi, że zmieniła 50,
to prawdopodobnie warunek był zbyt szeroki.

Przykład myślenia:

```text
Chcę zmienić jednego klienta -> spodziewam się 1 zmienionego wiersza.
Chcę zmienić wszystkie pending orders -> spodziewam się wielu wierszy.
Chcę usunąć jedną pozycję zamówienia -> spodziewam się 1 usuniętego wiersza.
```

W PostgreSQL bardzo pomaga w tym `RETURNING`, które będzie w osobnej lekcji.

## Dane w tej iteracji

Ćwiczenia używają tych samych 4 tabel co iteracja 1:

- `course.customers` - klienci,
- `course.products` - produkty,
- `course.orders` - zamówienia,
- `course.order_items` - pozycje zamówień.

## Najważniejsze rzeczy do zapamiętania

- DML zmienia dane.
- `SELECT` tylko czyta dane.
- `INSERT` dodaje wiersze.
- `UPDATE` zmienia wiersze.
- `DELETE` usuwa wiersze.
- `WHERE` przy `UPDATE` i `DELETE` jest krytyczny.
- Przed zmianą danych warto najpierw wykonać kontrolny `SELECT`.
- Po DML warto sprawdzić liczbę zmienionych wierszy.
- W data engineeringu DML często służy do ładowania i odświeżania danych.
