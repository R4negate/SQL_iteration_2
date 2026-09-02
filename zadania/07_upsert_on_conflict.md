# Zadania 07 - ON CONFLICT i upsert

## Zadanie 1

Spróbuj dodać klienta z `customer_id = 1`.

Zapisz jednym zdaniem, co się stało.

## Zadanie 2

Dodaj klienta z `customer_id = 1`, ale użyj:

```sql
ON CONFLICT (customer_id) DO NOTHING
```

## Zadanie 3

Sprawdź przez `SELECT`, czy dane klienta o `customer_id = 1` się zmieniły.

## Zadanie 4

Użyj `ON CONFLICT (customer_id) DO UPDATE`, żeby zmienić email i `acquisition_channel` klienta o `customer_id = 1`.

## Zadanie 5

Sprawdź przez `SELECT`, czy dane klienta zostały zmienione.

## Zadanie 6

Użyj `ON CONFLICT` dla tabeli `course.products`.

Jeżeli `product_id` już istnieje, zaktualizuj:

- `product_name`
- `category`
- `base_price`

## Zadanie 7

Użyj `ON CONFLICT` dla tabeli `course.products`, żeby dodać nowy produkt, którego jeszcze nie ma.

## Zadanie 8

Uruchom ponownie query z zadania 7.

Zapisz jednym zdaniem, czy powstał duplikat.

## Zadanie 9

Użyj `ON CONFLICT` dla tabeli `course.orders`.

Jeżeli `order_id` już istnieje, zaktualizuj:

- `customer_id`
- `order_date`
- `status`
- `total_amount`

## Zadanie 10

Użyj `ON CONFLICT` dla tabeli `course.order_items`.

Jeżeli `order_item_id` już istnieje, zaktualizuj:

- `order_id`
- `product_id`
- `quantity`
- `unit_price`

## Zadanie 11

Napisz jednym zdaniem, kiedy lepiej użyć `DO NOTHING`.

## Zadanie 12

Napisz jednym zdaniem, kiedy lepiej użyć `DO UPDATE`.

## Zadanie 13

Napisz jednym zdaniem, dlaczego upsert jest przydatny w pipeline danych.
