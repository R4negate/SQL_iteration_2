# SQL iteration 2 - DML

Ta iteracja dotyczy DML, czyli części SQL odpowiedzialnej za zmianę danych w tabelach.

Pracujemy na tych samych 4 tabelach co w iteracji 1:

- `course.customers`
- `course.products`
- `course.orders`
- `course.order_items`

W tej iteracji poznasz:

- `INSERT` - dodawanie nowych wierszy,
- `UPDATE` - zmienianie istniejących wierszy,
- `DELETE` - usuwanie wierszy,
- transakcje: `BEGIN`, `COMMIT`, `ROLLBACK`,
- `RETURNING`,
- `ON CONFLICT`,
- bezpieczny sposób pracy z danymi.

## Przygotowanie bazy

Przed rozpoczęciem uruchom skrypty z folderu:

```text
zadania/DDL
```

W tej kolejności:

1. `00_create_schema.sql`
2. `01_create_tables.sql`
3. `02_insert_seed_data.sql`
4. `03_smoke_test.sql`

Skrypty przygotowują schemat:

```text
course
```

Uwaga: skrypt `00_create_schema.sql` usuwa schemat `course` i tworzy go od nowa, więc resetuje dane.

## Kolejność nauki

1. `teoria/01_czym_jest_dml.md`
2. `teoria/02_insert.md`
3. `teoria/03_update.md`
4. `teoria/04_delete.md`
5. `teoria/05_transakcje.md`
6. `teoria/06_returning_i_bezpieczna_praca.md`
7. `teoria/07_upsert_on_conflict.md`

## Najważniejsza zasada

Przy `UPDATE` i `DELETE` najpierw napisz `SELECT`, który pokazuje rekordy, które chcesz zmienić albo usunąć.

Najpierw:

```sql
SELECT *
FROM course.customers
WHERE customer_id = 1;
```

Dopiero potem:

```sql
UPDATE course.customers
SET email = 'new.email@example.com'
WHERE customer_id = 1;
```

Brak `WHERE` przy `UPDATE` albo `DELETE` może zmienić albo usunąć wszystkie rekordy w tabeli.
