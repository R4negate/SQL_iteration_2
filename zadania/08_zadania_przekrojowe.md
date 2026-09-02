# Zadania 08 - zadania przekrojowe DML

## Zadanie 1

Dodaj nowego klienta.

Następnie dodaj dla niego nowe zamówienie.

Na końcu dodaj jedną pozycję tego zamówienia.

## Zadanie 2

Sprawdź przez `SELECT` z `JOIN`, czy nowy klient, zamówienie i pozycja zamówienia poprawnie się łączą.

Wynik powinien zawierać:

- `customer_name`
- `order_id`
- `product_id`
- `quantity`
- `unit_price`

## Zadanie 3

W transakcji zmień status nowego zamówienia na `cancelled`.

Sprawdź wynik przez `SELECT`, a potem cofnij zmianę przez `ROLLBACK`.

## Zadanie 4

Zmień status nowego zamówienia na `paid` i użyj `RETURNING *`.

## Zadanie 5

Dodaj nowy produkt przez `INSERT ... RETURNING`.

## Zadanie 6

Zaktualizuj produkt z poprzedniego zadania przez `ON CONFLICT DO UPDATE`.

## Zadanie 7

Usuń produkt z poprzedniego zadania przez `DELETE ... RETURNING`.

## Zadanie 8

Spróbuj usunąć klienta, dla którego istnieje zamówienie.

Zapisz jednym zdaniem, co się stało i dlaczego.

## Zadanie 9

Usuń najpierw pozycje zamówienia nowego klienta.

Potem usuń jego zamówienie.

Na końcu usuń klienta.

Każdy krok poprzedź kontrolnym `SELECT`.

## Zadanie 10

Dodaj produkt przez upsert:

- jeśli produkt nie istnieje, ma zostać dodany,
- jeśli produkt istnieje, ma zostać zaktualizowana cena.

## Zadanie 11

Ustaw wszystkim produktom z kategorii `ebook` cenę większą o 5%.

Przed zmianą wykonaj kontrolny `SELECT`.

## Zadanie 12

W jednym krótkim opisie napisz bezpieczny schemat pracy z DML:

- co robisz przed zmianą,
- jak wykonujesz zmianę,
- jak sprawdzasz wynik,
- kiedy używasz transakcji.
