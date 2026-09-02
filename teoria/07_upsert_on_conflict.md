# 07 - ON CONFLICT i upsert

## Problem duplikatu

Jeżeli spróbujesz dodać rekord z takim samym kluczem głównym, baza zgłosi błąd.

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
    1,
    'Duplicate Customer',
    'duplicate@example.com',
    'PL',
    '2026-06-01',
    'google'
);
```

Jeśli `customer_id = 1` już istnieje, baza nie pozwoli dodać drugiego klienta z tym samym identyfikatorem.

## ON CONFLICT DO NOTHING

Jeżeli konflikt ma zostać zignorowany, można użyć:

```sql
ON CONFLICT (customer_id) DO NOTHING
```

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
    1,
    'Duplicate Customer',
    'duplicate@example.com',
    'PL',
    '2026-06-01',
    'google'
)
ON CONFLICT (customer_id) DO NOTHING;
```

Znaczenie:

```text
Spróbuj dodać rekord. Jeśli customer_id już istnieje, nic nie rób.
```

## Upsert

Upsert oznacza:

```text
insert + update
```

Czyli:

- jeśli rekordu nie ma, wstaw go,
- jeśli rekord już istnieje, zaktualizuj go.

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
    1,
    'Anna Kowalska',
    'anna.new@example.com',
    'PL',
    '2026-01-05',
    'newsletter'
)
ON CONFLICT (customer_id) DO UPDATE SET
    customer_name = EXCLUDED.customer_name,
    email = EXCLUDED.email,
    country = EXCLUDED.country,
    signup_date = EXCLUDED.signup_date,
    acquisition_channel = EXCLUDED.acquisition_channel;
```

## Co oznacza EXCLUDED

`EXCLUDED` oznacza wartości, które próbowaliśmy wstawić.

W tym fragmencie:

```sql
email = EXCLUDED.email
```

znaczenie jest takie:

```text
Ustaw email w istniejącym rekordzie na email z nowej wersji rekordu.
```

## ON CONFLICT działa na kluczu albo unikalności

`ON CONFLICT` musi wiedzieć, gdzie konflikt może wystąpić.

Najczęściej jest to:

- `PRIMARY KEY`,
- kolumna z `UNIQUE`,
- zestaw kolumn z unikalnym ograniczeniem.

Przykład:

```sql
ON CONFLICT (customer_id)
```

czyli konflikt jest sprawdzany po `customer_id`.

## Po co upsert w data engineeringu

Upsert jest bardzo ważny w pipeline'ach danych.

Pipeline może pobrać ten sam rekord więcej niż raz.

Bez upsertu pipeline może:

- zakończyć się błędem przez duplikat,
- wstawić duplikaty, jeśli tabela nie ma klucza,
- zostawić starą wersję danych.

Z upsertem pipeline może działać powtarzalnie:

```text
Ten sam input uruchomiony drugi raz nie powinien popsuć tabeli.
```

## DO NOTHING vs DO UPDATE

`DO NOTHING` ignoruje konflikt i nie zmienia istniejącego rekordu.

`DO UPDATE` aktualizuje istniejący rekord wartościami z nowej wersji rekordu.

## Upsert a idempotencja

Idempotencja oznacza, że ponowne uruchomienie tej samej operacji nie psuje
danych.

Przykład problemu:

```text
Pipeline pobiera stronę danych z API.
Wstawia rekordy do tabeli.
Pipeline zostaje uruchomiony drugi raz dla tej samej strony.
```

Jeżeli użyjemy zwykłego `INSERT`, mogą wydarzyć się dwie rzeczy:

- baza zgłosi błąd duplikatu klucza,
- albo, jeśli tabela nie ma dobrego klucza, pojawią się duplikaty.

Upsert rozwiązuje ten problem:

```text
Jeśli rekord już istnieje, zaktualizuj go zamiast dodawać drugi raz.
```

To jest jeden z najważniejszych wzorców w data engineeringu.

## ON CONFLICT dla klucza z kilku kolumn

Konflikt może dotyczyć nie tylko jednej kolumny.

W tabelach typu `order_items` często naturalnym kluczem może być para:

```text
order_id + line_number
```

Przykład koncepcyjny:

```sql
INSERT INTO course.order_items (
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    discount_pct
)
VALUES (
    9001,
    1001,
    101,
    2,
    49.99,
    0
)
ON CONFLICT (order_item_id) DO UPDATE SET
    order_id = EXCLUDED.order_id,
    product_id = EXCLUDED.product_id,
    quantity = EXCLUDED.quantity,
    unit_price = EXCLUDED.unit_price,
    discount_pct = EXCLUDED.discount_pct;
```

W naszych tabelach `course.order_items` kluczem głównym jest `order_item_id`.

W innych modelach można spotkać też klucze złożone, np.:

```sql
ON CONFLICT (order_id, line_number) DO UPDATE SET ...
```

Warunek w `ON CONFLICT (...)` musi pasować do istniejącego `PRIMARY KEY` albo
unikalnego ograniczenia.

## DO UPDATE z warunkiem

`DO UPDATE` może mieć dodatkowy warunek `WHERE`.

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
VALUES (
    1,
    'Anna Kowalska',
    'anna.new@example.com',
    'PL',
    '2026-01-05',
    'newsletter'
)
ON CONFLICT (customer_id) DO UPDATE SET
    email = EXCLUDED.email,
    acquisition_channel = EXCLUDED.acquisition_channel
WHERE course.customers.email IS DISTINCT FROM EXCLUDED.email
   OR course.customers.acquisition_channel IS DISTINCT FROM EXCLUDED.acquisition_channel;
```

Znaczenie:

```text
Aktualizuj istniejący rekord tylko wtedy, gdy wybrane wartości naprawdę się zmieniły.
```

To nie zawsze jest potrzebne na początku nauki, ale warto znać kierunek:
upsert może być prosty albo bardziej kontrolowany.

## Czego nie robić

Nie należy traktować `ON CONFLICT DO NOTHING` jako zawsze najlepszego
rozwiązania.

`DO NOTHING` ukrywa konflikt.

To jest dobre, gdy naprawdę chcemy ignorować duplikat.

Ale jeżeli źródło przysłało nowszą wersję rekordu, `DO NOTHING` zostawi starą
wersję danych.

Wtedy lepsze jest `DO UPDATE`.

Prosta zasada:

```text
duplikat ma być zignorowany -> DO NOTHING
duplikat oznacza nowszą wersję danych -> DO UPDATE
```

## Najważniejsze rzeczy do zapamiętania

- `ON CONFLICT` obsługuje konflikt na kluczu albo unikalnym ograniczeniu.
- `DO NOTHING` ignoruje konflikt.
- `DO UPDATE` aktualizuje istniejący rekord.
- `EXCLUDED` oznacza nową wersję rekordu.
- Upsert pomaga budować pipeline'y, które można uruchamiać wielokrotnie bez duplikatów.
- Idempotencja oznacza, że ponowne uruchomienie procesu nie psuje danych.
- `ON CONFLICT` może działać na jednej kolumnie albo na zestawie kolumn, jeśli istnieje unikalność.
- `DO NOTHING` i `DO UPDATE` mają różne zastosowania biznesowe.
