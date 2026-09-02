# Zadania SQL - iteration 2 DML

Przed rozpoczęciem uruchom skrypty z folderu `DDL`:

1. `00_create_schema.sql`
2. `01_create_tables.sql`
3. `02_insert_seed_data.sql`
4. `03_smoke_test.sql`

W zadaniach używaj tych samych 4 tabel co w iteracji 1:

- `course.customers`
- `course.products`
- `course.orders`
- `course.order_items`

Kolejność zadań:

1. `01_czym_jest_dml.md`
2. `02_insert.md`
3. `03_update.md`
4. `04_delete.md`
5. `05_transakcje.md`
6. `06_returning_i_bezpieczna_praca.md`
7. `07_upsert_on_conflict.md`
8. `08_zadania_przekrojowe.md`

## Ważna zasada

Przed każdym `UPDATE` i `DELETE` najpierw napisz `SELECT`, który pokazuje rekordy, które zostaną zmienione albo usunięte.

Jeżeli chcesz wrócić do danych początkowych, uruchom ponownie skrypty z folderu `DDL`.
