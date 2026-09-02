# 04 - DELETE

## Do czego służy DELETE

`DELETE` usuwa wiersze z tabeli.

Podstawowa składnia:

```sql
DELETE FROM schema.table_name
WHERE condition;
```

## DELETE jednego rekordu

```sql
DELETE FROM course.order_items
WHERE order_item_id = 14;
```

To query usuwa jedną pozycję zamówienia.

## Najpierw SELECT

Przed `DELETE` sprawdź, co zostanie usunięte:

```sql
SELECT *
FROM course.order_items
WHERE order_item_id = 14;
```

Dopiero potem wykonaj:

```sql
DELETE FROM course.order_items
WHERE order_item_id = 14;
```

Po usunięciu sprawdź:

```sql
SELECT *
FROM course.order_items
WHERE order_item_id = 14;
```

## DELETE wielu rekordów

```sql
DELETE FROM course.order_items
WHERE order_id = 1012;
```

To usuwa wszystkie pozycje zamówienia `1012`.

## DELETE bez WHERE

To query usuwa wszystkie rekordy z tabeli:

```sql
DELETE FROM course.order_items;
```

Tabela nadal istnieje, ale jej zawartość znika.

To jest bardzo niebezpieczne, jeżeli nie było celowe.

Dlatego przy `DELETE` bez `WHERE` zatrzymaj się i zadaj pytanie:

> Czy naprawdę chcę usunąć wszystkie wiersze z tej tabeli?

## DELETE a foreign key

Niektórych rekordów nie da się usunąć, jeśli inne tabele nadal się do nich odnoszą.

Przykład:

```sql
DELETE FROM course.customers
WHERE customer_id = 1;
```

Jeśli klient ma zamówienia, baza może zablokować usunięcie, bo `course.orders.customer_id` wskazuje na `course.customers.customer_id`.

To jest dobra rzecz. Baza chroni spójność danych.

## Kolejność DELETE przy powiązanych tabelach

Przy tabelach połączonych relacją parent-child kolejność usuwania ma znaczenie.

Przykład:

```text
orders      -> tabela nadrzędna dla zamówienia
order_items -> tabela zależna, pozycje zamówienia
```

Jeżeli `order_items.order_id` wskazuje na `orders.order_id`, to nie zawsze można
usunąć zamówienie, dopóki istnieją jego pozycje.

Bezpieczna kolejność zwykle wygląda tak:

1. usuń rekordy zależne,
2. usuń rekord nadrzędny.

Przykład:

```sql
DELETE FROM course.order_items
WHERE order_id = 1012;

DELETE FROM course.orders
WHERE order_id = 1012;
```

To chroni przed sytuacją, w której pozycje zamówienia wskazują na zamówienie,
którego już nie ma.

## DELETE USING

W PostgreSQL można usuwać rekordy na podstawie połączenia z inną tabelą przez `DELETE ... USING`.

Przykład:

```sql
DELETE FROM course.order_items oi
USING course.orders o
WHERE oi.order_id = o.order_id
  AND o.status = 'cancelled';
```

Znaczenie:

```text
Usuń pozycje zamówień, które mają status cancelled.
```

Przed takim `DELETE` najpierw napisz kontrolny `SELECT`:

```sql
SELECT
    oi.order_item_id,
    oi.order_id,
    o.status
FROM course.order_items oi
JOIN course.orders o
    ON oi.order_id = o.order_id
WHERE o.status = 'cancelled';
```

## DELETE vs DROP

`DELETE` usuwa dane z tabeli.

`DROP TABLE` usuwa całą tabelę.

Przykład:

```sql
DELETE FROM course.order_items;
```

usuwa wiersze, ale tabela zostaje.

```sql
DROP TABLE course.order_items;
```

usuwa tabelę jako obiekt.

## DELETE vs TRUNCATE

`TRUNCATE` też usuwa dane z tabeli, ale działa inaczej niż `DELETE`.

Ogólna intuicja:

```text
DELETE   -> usuwa wybrane wiersze, może mieć WHERE
TRUNCATE -> szybko czyści całą tabelę
```

Przykład:

```sql
TRUNCATE TABLE course.order_items;
```

`TRUNCATE` nie służy do usuwania kilku wybranych rekordów. To narzędzie do
wyczyszczenia całej tabeli.

Na początku kursu ostrożnie używamy `DELETE`, bo łatwiej zrozumieć, które
wiersze usuwamy.

## Soft delete

W prawdziwych systemach często nie usuwa się danych fizycznie.

Zamiast tego ustawia się flagę albo status.

Przykład koncepcyjny:

```sql
UPDATE course.orders
SET status = 'cancelled'
WHERE order_id = 1003;
```

To nie usuwa zamówienia z tabeli, tylko zmienia jego status.

Taki sposób bywa nazywany `soft delete`, czyli miękkie usunięcie.

Dlaczego to przydatne:

- zachowujemy historię,
- łatwiej audytować zmiany,
- raporty mogą uwzględniać anulowane rekordy,
- nie zrywamy relacji z innymi tabelami.

Fizyczny `DELETE` stosujemy wtedy, gdy naprawdę chcemy usunąć rekord z tabeli,
np. przy danych testowych, tabelach roboczych albo retencji danych.

## Najważniejsze rzeczy do zapamiętania

- `DELETE` usuwa rekordy.
- `WHERE` mówi, które rekordy usunąć.
- Brak `WHERE` usuwa całą zawartość tabeli.
- Przed `DELETE` warto zrobić kontrolny `SELECT`.
- Klucze obce mogą zablokować usuwanie danych.
- Przy tabelach zależnych często najpierw usuwa się rekordy child, potem parent.
- `TRUNCATE` czyści całą tabelę i nie ma `WHERE`.
- Czasem zamiast fizycznego usuwania lepszy jest soft delete, np. zmiana statusu na cancelled.
