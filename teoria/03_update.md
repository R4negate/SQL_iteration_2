# 03 - UPDATE

## Do czego służy UPDATE

`UPDATE` zmienia istniejące wiersze w tabeli.

Podstawowa składnia:

```sql
UPDATE schema.table_name
SET column_name = new_value
WHERE condition;
```

## UPDATE jednego rekordu

```sql
UPDATE course.customers
SET email = 'anna.new@example.com'
WHERE customer_id = 1;
```

To query zmienia email tylko temu klientowi, który ma `customer_id = 1`.

## Najpierw SELECT

Przed `UPDATE` sprawdź, co zostanie zmienione:

```sql
SELECT *
FROM course.customers
WHERE customer_id = 1;
```

Najważniejsza zasada:

> `WHERE` z kontrolnego `SELECT` powinien być taki sam jak `WHERE` w `UPDATE`.

Jeżeli kontrolny `SELECT` pokazuje 1 rekord, `UPDATE` powinien zmienić 1 rekord.
Jeżeli kontrolny `SELECT` pokazuje 100 rekordów, `UPDATE` może zmienić 100
rekordów.

Potem wykonaj `UPDATE`.

Po zmianie sprawdź wynik:

```sql
SELECT *
FROM course.customers
WHERE customer_id = 1;
```

## UPDATE wielu kolumn

```sql
UPDATE course.customers
SET
    email = 'new.email@example.com',
    acquisition_channel = 'linkedin'
WHERE customer_id = 6;
```

W `SET` można zmienić więcej niż jedną kolumnę.

## UPDATE wielu rekordów

```sql
UPDATE course.orders
SET status = 'paid'
WHERE status = 'pending'
  AND total_amount < 100;
```

To query może zmienić wiele rekordów, jeśli wiele zamówień spełnia warunek.

Dlatego wcześniej warto wykonać:

```sql
SELECT *
FROM course.orders
WHERE status = 'pending'
  AND total_amount < 100;
```

## UPDATE z obliczeniem

Można ustawić nową wartość na podstawie starej wartości:

```sql
UPDATE course.products
SET base_price = base_price * 1.10
WHERE category = 'course';
```

To podnosi cenę produktów z kategorii `course` o 10%.

## UPDATE z NULL

Można ustawić kolumnę na `NULL`, jeśli kolumna dopuszcza brak wartości:

```sql
UPDATE course.customers
SET email = NULL
WHERE customer_id = 6;
```

## UPDATE bez WHERE

To query zmieni wszystkie rekordy w tabeli:

```sql
UPDATE course.customers
SET country = 'PL';
```

Przy `UPDATE` brak `WHERE` jest jednym z najczęstszych i najgroźniejszych błędów.

## UPDATE z RETURNING

W PostgreSQL można od razu zobaczyć zmienione rekordy przez `RETURNING`.

```sql
UPDATE course.customers
SET email = 'anna.new@example.com'
WHERE customer_id = 1
RETURNING customer_id, customer_name, email;
```

To query:

1. zmienia email,
2. od razu pokazuje rekord po zmianie.

`RETURNING` pomaga sprawdzić, czy zmieniły się dokładnie te dane, które miały
się zmienić.

## UPDATE z warunkiem po innej tabeli

W PostgreSQL można aktualizować tabelę na podstawie danych z drugiej tabeli przez `UPDATE ... FROM`.

Przykład:

```sql
UPDATE course.orders o
SET total_amount = oi.items_value
FROM (
    SELECT
        order_id,
        SUM(quantity * unit_price) AS items_value
    FROM course.order_items
    GROUP BY order_id
) oi
WHERE o.order_id = oi.order_id;
```

Znaczenie:

```text
Ustaw wartość zamówienia na sumę jego pozycji.
```

Najpierw warto napisać wersję kontrolną jako `SELECT`.

```sql
SELECT
    o.order_id,
    o.total_amount,
    oi.items_value
FROM course.orders o
JOIN (
    SELECT
        order_id,
        SUM(quantity * unit_price) AS items_value
    FROM course.order_items
    GROUP BY order_id
) oi
    ON o.order_id = oi.order_id;
```

## UPDATE tylko wtedy, gdy wartość naprawdę się zmieniła

Czasami nie chcemy aktualizować rekordu, jeśli nowa wartość jest taka sama jak
stara.

W PostgreSQL przydaje się do tego `IS DISTINCT FROM`.

Przykład:

```sql
UPDATE course.customers
SET email = 'anna.new@example.com'
WHERE customer_id = 1
  AND email IS DISTINCT FROM 'anna.new@example.com';
```

To znaczy:

```text
Zmień email tylko wtedy, gdy obecny email jest inny od nowego.
```

`IS DISTINCT FROM` jest bezpieczniejsze niż `<>`, gdy w grę wchodzi `NULL`.

Przykład:

```sql
NULL <> 'x'
```

nie daje zwykłego `TRUE`, bo `NULL` oznacza wartość nieznaną.

`IS DISTINCT FROM` traktuje `NULL` w bardziej praktyczny sposób przy porównaniu
starej i nowej wartości.

## UPDATE w data engineeringu

W pipeline'ach danych `UPDATE` pojawia się często przy:

- poprawianiu statusu przetwarzania,
- aktualizacji tabel technicznych,
- oznaczaniu rekordów jako przetworzone,
- zmianie flag jakości danych,
- upsercie, czyli `INSERT ... ON CONFLICT DO UPDATE`.

Przykład myślenia:

```text
Rekord był już w tabeli.
Źródło przysłało nowszą wersję.
Nie dodajemy duplikatu, tylko aktualizujemy istniejący rekord.
```

Ten wzorzec będzie rozwinięty w lekcji o `ON CONFLICT`.

## Najważniejsze rzeczy do zapamiętania

- `UPDATE` zmienia istniejące rekordy.
- `SET` mówi, co zmienić.
- `WHERE` mówi, które rekordy zmienić.
- Brak `WHERE` może zmienić całą tabelę.
- Przed `UPDATE` warto napisać kontrolny `SELECT`.
- `RETURNING` pozwala zobaczyć zmienione rekordy.
- `UPDATE ... FROM` pozwala aktualizować dane na podstawie innej tabeli.
- `IS DISTINCT FROM` pomaga porównywać wartości także wtedy, gdy może wystąpić `NULL`.
