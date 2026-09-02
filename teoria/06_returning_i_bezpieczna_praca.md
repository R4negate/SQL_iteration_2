# 06 - RETURNING i bezpieczna praca

## Po co jest RETURNING

W PostgreSQL polecenia `INSERT`, `UPDATE` i `DELETE` mogą od razu zwrócić rekordy, których dotyczyła operacja.

Służy do tego `RETURNING`.

To jest przydatne, bo od razu widzisz:

- co zostało dodane,
- co zostało zmienione,
- co zostało usunięte.

`RETURNING` jest szczególnie przydatne podczas nauki i podczas pracy
administracyjnej, bo zmniejsza ryzyko działania "w ciemno".

Zamiast wykonywać zmianę i dopiero potem osobny `SELECT`, możemy od razu dostać
informację, których rekordów dotknęła operacja.

## INSERT RETURNING

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
    20,
    'Returned Customer',
    'returned.customer@example.com',
    'PL',
    '2026-06-20',
    'google'
)
RETURNING *;
```

## UPDATE RETURNING

```sql
UPDATE course.orders
SET status = 'paid'
WHERE order_id = 1003
RETURNING order_id, status, total_amount;
```

To query zmienia rekord i od razu pokazuje nową wartość.

## DELETE RETURNING

```sql
DELETE FROM course.order_items
WHERE order_item_id = 14
RETURNING *;
```

To query usuwa rekord i pokazuje, co zostało usunięte.

## Bezpieczny schemat pracy z UPDATE

Najpierw:

```sql
SELECT *
FROM course.orders
WHERE order_id = 1003;
```

Potem:

```sql
UPDATE course.orders
SET status = 'paid'
WHERE order_id = 1003
RETURNING *;
```

## Bezpieczny schemat pracy z DELETE

Najpierw:

```sql
SELECT *
FROM course.order_items
WHERE order_item_id = 14;
```

Potem:

```sql
DELETE FROM course.order_items
WHERE order_item_id = 14
RETURNING *;
```

## RETURNING z transakcją

```sql
BEGIN;

UPDATE course.products
SET base_price = base_price * 1.10
WHERE product_id = 101
RETURNING *;

ROLLBACK;
```

Najpierw testujesz zmianę. Jeśli wszystko wygląda dobrze, następnym razem możesz użyć `COMMIT`.

## RETURNING a liczba zmienionych wierszy

`RETURNING` pomaga zauważyć, czy warunek był za szeroki albo za wąski.

Przykład:

```sql
UPDATE course.orders
SET status = 'paid'
WHERE status = 'pending'
RETURNING order_id, status;
```

Jeżeli spodziewasz się jednego rekordu, a `RETURNING` pokazuje dziesięć, to jest
sygnał, że `WHERE` prawdopodobnie jest zbyt szeroki.

Jeżeli spodziewasz się rekordu, a `RETURNING` nic nie pokazuje, to znaczy, że
żaden wiersz nie spełnił warunku.

## Bezpieczny schemat pracy z DML

Przy `UPDATE` i `DELETE` warto pracować według tego schematu:

1. Napisz `SELECT`.
2. Sprawdź wynik.
3. Uruchom `BEGIN`.
4. Wykonaj `UPDATE` albo `DELETE` z `RETURNING`.
5. Sprawdź zwrócone rekordy.
6. Zrób `COMMIT` albo `ROLLBACK`.

Przykład:

```sql
SELECT *
FROM course.orders
WHERE order_id = 1003;

BEGIN;

UPDATE course.orders
SET status = 'paid'
WHERE order_id = 1003
RETURNING *;

ROLLBACK;
```

Na początku nauki `ROLLBACK` jest bardzo wygodny, bo pozwala bezpiecznie
przećwiczyć zmianę bez zostawiania jej w bazie.

## Czego RETURNING nie zastępuje

`RETURNING` nie zastępuje myślenia o warunku `WHERE`.

Jeżeli napiszesz:

```sql
DELETE FROM course.order_items
RETURNING *;
```

to baza pokaże usunięte rekordy, ale rekordy i tak zostały usunięte.

Dlatego `RETURNING` jest narzędziem kontroli, ale nie jest zabezpieczeniem przed
źle napisanym DML.

## Najważniejsze rzeczy do zapamiętania

- `RETURNING` pokazuje rekordy zmienione przez DML.
- `RETURNING *` pokazuje wszystkie kolumny.
- `RETURNING column_name` pokazuje tylko wybrane kolumny.
- `RETURNING` jest bardzo przydatne przy `INSERT`, `UPDATE` i `DELETE`.
- `RETURNING` pomaga kontrolować, ile i jakie rekordy zmieniła operacja.
- `RETURNING` nie zastępuje poprawnego `WHERE`.
