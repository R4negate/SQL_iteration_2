# DDL - przygotowanie danych do DML

Ten folder przygotowuje te same 4 tabele, na których pracowaliśmy w iteracji 1:

- `course.customers`
- `course.products`
- `course.orders`
- `course.order_items`

Uruchom pliki w kolejności:

1. `00_create_schema.sql`
2. `01_create_tables.sql`
3. `02_insert_seed_data.sql`
4. `03_smoke_test.sql`

Skrypt `00_create_schema.sql` usuwa i tworzy od nowa schemat:

```text
course
```

Dzięki temu możesz łatwo wrócić do stanu startowego po ćwiczeniach z `INSERT`, `UPDATE` i `DELETE`.

## Kiedy uruchomić te skrypty ponownie

Uruchom je ponownie, jeśli:

- chcesz zacząć iterację od początku,
- zrobiłeś błędny `UPDATE`,
- zrobiłeś błędny `DELETE`,
- masz inne wyniki niż w zadaniach,
- chcesz mieć czysty zestaw danych przed kolejną lekcją.

Uwaga: reset schematu `course` usuwa dane z tych tabel i wstawia je ponownie ze skryptu startowego.

