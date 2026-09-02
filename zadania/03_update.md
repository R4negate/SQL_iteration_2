# Zadania 03 - UPDATE

## Zadanie 1

Napisz kontrolny `SELECT`, który pokazuje klienta o `customer_id = 6`.

## Zadanie 2

Zmień email klienta o `customer_id = 6`.

## Zadanie 3

Sprawdź przez `SELECT`, czy email został zmieniony.

## Zadanie 4

Zmień `acquisition_channel` klienta o `customer_id = 6` na `linkedin`.

## Zadanie 5

Sprawdź przez `SELECT`, czy kanał pozyskania został zmieniony.

## Zadanie 6

Podnieś cenę wszystkich produktów z kategorii `course` o 10%.

## Zadanie 7

Sprawdź przez `SELECT`, jakie są nowe ceny produktów z kategorii `course`.

## Zadanie 8

Zmień status zamówień `pending` na `paid`, ale tylko dla zamówień o wartości mniejszej niż `100`.

## Zadanie 9

Sprawdź przez `SELECT`, które zamówienia mają teraz status `paid` i wartość mniejszą niż `100`.

## Zadanie 10

Zmień `country` klientom z `FR` na `PL`.

Przed zmianą wykonaj kontrolny `SELECT`.

## Zadanie 11

Zmień `unit_price` pozycji zamówienia o `order_item_id = 1` na `130.00`.

## Zadanie 12

Zmień `quantity` wszystkich pozycji dla produktu `product_id = 103` na `2`.

Przed zmianą wykonaj kontrolny `SELECT`.

## Zadanie 13

Napisz jednym zdaniem, co mogłoby się stać, gdyby w `UPDATE` zabrakło `WHERE`.

## Zadanie 14

Napisz kontrolny `SELECT`, który dla każdego zamówienia pokazuje:

- `order_id`
- obecne `total_amount`
- sumę pozycji `quantity * unit_price`

## Zadanie 15

Użyj `UPDATE ... FROM`, żeby ustawić `orders.total_amount` na sumę pozycji zamówienia.
