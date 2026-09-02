# Zadania 06 - RETURNING i bezpieczna praca

## Zadanie 1

Dodaj nowego klienta do `course.customers` i użyj `RETURNING *`.

## Zadanie 2

Dodaj nowy produkt do `course.products` i użyj `RETURNING product_id, product_name, base_price`.

## Zadanie 3

Zmień status zamówienia o `order_id = 1003` i zwróć zmieniony rekord przez `RETURNING *`.

## Zadanie 4

Zmień email klienta o `customer_id = 3` i zwróć tylko:

- `customer_id`
- `customer_name`
- `email`

## Zadanie 5

Usuń pozycję zamówienia o `order_item_id = 14` i użyj `RETURNING *`.

## Zadanie 6

Usuń produkt, którego nie ma w `course.order_items`, i zwróć:

- `product_id`
- `product_name`

## Zadanie 7

Wykonaj `UPDATE` w transakcji:

1. `BEGIN`
2. kontrolny `SELECT`
3. `UPDATE ... RETURNING`
4. `ROLLBACK`

## Zadanie 8

Wykonaj `DELETE` w transakcji:

1. `BEGIN`
2. kontrolny `SELECT`
3. `DELETE ... RETURNING`
4. `ROLLBACK`

## Zadanie 9

Napisz jednym zdaniem, dlaczego `RETURNING` jest przydatne przy `UPDATE`.

## Zadanie 10

Napisz jednym zdaniem, dlaczego `RETURNING` jest przydatne przy `DELETE`.
