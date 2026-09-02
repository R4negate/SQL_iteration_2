# 02 - INSERT

## Do czego służy INSERT

`INSERT` dodaje nowe wiersze do tabeli.

Podstawowa składnia:

```sql
INSERT INTO schema.table_name (
    column_1,
    column_2
)
VALUES (
    value_1,
    value_2
);
```

## INSERT jednego klienta

```sql
INSERT INTO course.customers (
    customer_id,
    customer_name,
    email,
    country,
    signup_date,
    acquisition_channel
)
VALUES (
    9,
    'Test Customer',
    'test.customer@example.com',
    'PL',
    '2026-06-01',
    'google'
);
```

## Dlaczego warto podawać listę kolumn

W `INSERT` warto jawnie wypisywać kolumny.

Dzięki temu widać:

- do której kolumny trafia dana wartość,
- czy liczba kolumn zgadza się z liczbą wartości,
- czy nie pomijamy wymaganej kolumny,
- czy query pozostanie czytelne po czasie.

Nie warto pisać tak:

```sql
INSERT INTO course.customers
VALUES (
    9,
    'Test Customer',
    'test.customer@example.com',
    'PL',
    '2026-06-01',
    'google'
);
```

To może zadziałać, ale jest kruche. Jeżeli ktoś zmieni kolejność kolumn w tabeli
albo doda nową kolumnę, takie query robi się nieczytelne i ryzykowne.

Lepszy nawyk:

```sql
INSERT INTO course.customers (
    customer_id,
    customer_name,
    email,
    country,
    signup_date,
    acquisition_channel
)
VALUES (...);
```

W data engineeringu jawna lista kolumn jest bardzo ważna, bo pipeline powinien
jasno pokazywać, jak mapuje dane źródłowe do tabeli docelowej.

## INSERT wielu wierszy

Jednym `INSERT` można dodać kilka rekordów:

```sql
INSERT INTO course.products (
    product_id,
    product_name,
    category,
    base_price
)
VALUES
    (201, 'SQL Practice Pack', 'course', 99.00),
    (202, 'Data Notes PDF', 'ebook', 29.00);
```

## NULL w INSERT

`NULL` oznacza brak wartości.

Przykład:

```sql
INSERT INTO course.customers (
    customer_id,
    customer_name,
    email,
    country,
    signup_date,
    acquisition_channel
)
VALUES (
    10,
    'Customer Without Email',
    NULL,
    'FR',
    '2026-06-03',
    'organic'
);
```

Możesz wstawić `NULL` tylko wtedy, gdy kolumna na to pozwala.

## DEFAULT w INSERT

Niektóre kolumny mogą mieć wartość domyślną.

Jeżeli tabela ma kolumnę z `DEFAULT`, baza może sama uzupełnić wartość, gdy jej
nie podamy.

Przykład ogólny:

```sql
INSERT INTO some_table (
    id,
    status
)
VALUES (
    1,
    DEFAULT
);
```

`DEFAULT` oznacza:

```text
Użyj wartości domyślnej z definicji tabeli.
```

W naszych tabelach kursowych nie musimy mocno opierać się na `DEFAULT`, ale
warto znać ten mechanizm, bo często pojawia się w tabelach produkcyjnych, np.
przy statusach, datach utworzenia albo flagach technicznych.

## INSERT a primary key

Jeżeli kolumna jest `PRIMARY KEY`, jej wartość musi być unikalna.

To się nie uda, jeśli `customer_id = 1` już istnieje:

```sql
INSERT INTO course.customers (
    customer_id,
    customer_name,
    email,
    country,
    signup_date,
    acquisition_channel
)
VALUES (
    1,
    'Duplicate Customer',
    'duplicate@example.com',
    'PL',
    '2026-06-01',
    'google'
);
```

## INSERT a foreign key

Jeżeli tabela ma `FOREIGN KEY`, nie można wskazać rekordu, którego nie ma w tabeli nadrzędnej.

To się nie uda, jeśli klient `999` nie istnieje:

```sql
INSERT INTO course.orders (
    order_id,
    customer_id,
    order_date,
    status,
    total_amount
)
VALUES (
    2001,
    999,
    '2026-06-10',
    'paid',
    100.00
);
```

## Kolejność INSERT przy powiązanych tabelach

Przy tabelach połączonych kluczami obcymi kolejność ma znaczenie.

Najpierw trzeba wstawić rekord nadrzędny, a dopiero potem rekord zależny.

Przykład:

1. Najpierw klient:

```sql
INSERT INTO course.customers (
    customer_id,
    customer_name,
    email,
    country,
    signup_date,
    acquisition_channel
)
VALUES (
    30,
    'Parent Customer',
    'parent.customer@example.com',
    'PL',
    '2026-06-01',
    'google'
);
```

2. Potem zamówienie tego klienta:

```sql
INSERT INTO course.orders (
    order_id,
    customer_id,
    order_date,
    status,
    total_amount
)
VALUES (
    3001,
    30,
    '2026-06-10',
    'paid',
    100.00
);
```

Jeżeli spróbujesz najpierw wstawić zamówienie dla klienta `30`, a klienta nie ma
jeszcze w `course.customers`, baza może zablokować zapis przez `FOREIGN KEY`.

## INSERT INTO ... SELECT

`INSERT` nie musi brać danych tylko z ręcznie wpisanego `VALUES`.

Może też wstawić wynik zapytania `SELECT`.

Ogólny schemat:

```sql
INSERT INTO target_table (
    column_1,
    column_2
)
SELECT
    source_column_1,
    source_column_2
FROM source_table;
```

To jest bardzo ważne w data engineeringu, bo często przenosimy dane z jednej
tabeli do drugiej.

Przykład koncepcyjny:

```sql
INSERT INTO course.customers (
    customer_id,
    customer_name,
    email,
    country,
    signup_date,
    acquisition_channel
)
SELECT
    customer_id,
    customer_name,
    email,
    country,
    signup_date,
    acquisition_channel
FROM course.customers
WHERE country = 'PL';
```

Ten przykład pokazuje mechanizm. W praktyce nie wstawialibyśmy tych samych
klientów do tej samej tabeli, bo naruszylibyśmy `PRIMARY KEY`.

Najważniejsza idea:

> `INSERT ... SELECT` służy do ładowania danych wynikiem zapytania.

## INSERT a idempotencja

Zwykły `INSERT` może być problemem, gdy uruchamiasz ten sam skrypt drugi raz.

Jeżeli rekord z takim samym `PRIMARY KEY` już istnieje, baza zgłosi błąd.

W pipeline'ach danych często chcemy, żeby ponowne uruchomienie procesu nie
psuło danych.

Do tego służą wzorce:

- `ON CONFLICT DO NOTHING`,
- `ON CONFLICT DO UPDATE`.

Te mechanizmy będą w lekcji o upsercie.

## Najważniejsze rzeczy do zapamiętania

- `INSERT` dodaje nowe wiersze.
- Warto zawsze podawać listę kolumn.
- Liczba kolumn musi pasować do liczby wartości.
- Teksty i daty zapisujemy w apostrofach.
- Liczby zapisujemy bez apostrofów.
- `NULL` oznacza brak wartości.
- `PRIMARY KEY` nie może się powtórzyć.
- `FOREIGN KEY` musi wskazywać istniejący rekord.
- Przy tabelach powiązanych najpierw wstawiamy rekord nadrzędny, potem zależny.
- `INSERT ... SELECT` pozwala wstawić wynik zapytania.
- Zwykły `INSERT` nie jest bezpieczny przy ponownym uruchomieniu tego samego ładowania.
