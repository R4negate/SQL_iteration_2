# 05 - Transakcje

## Po co są transakcje

Transakcja pozwala wykonać kilka operacji jako jedną całość.

Możesz:

- rozpocząć transakcję,
- wykonać zmiany,
- sprawdzić wynik,
- zatwierdzić zmiany przez `COMMIT`,
- albo cofnąć zmiany przez `ROLLBACK`.

## BEGIN

`BEGIN` rozpoczyna transakcję.

```sql
BEGIN;
```

## COMMIT

`COMMIT` zatwierdza zmiany.

```sql
COMMIT;
```

Po `COMMIT` zmiany zostają zapisane.

## ROLLBACK

`ROLLBACK` cofa zmiany wykonane w transakcji.

```sql
ROLLBACK;
```

Po `ROLLBACK` wracasz do stanu sprzed `BEGIN`.

## Przykład z ROLLBACK

```sql
BEGIN;

UPDATE course.orders
SET status = 'cancelled'
WHERE order_id = 1003;

SELECT *
FROM course.orders
WHERE order_id = 1003;

ROLLBACK;
```

Po `ROLLBACK` zmiana statusu zostanie cofnięta.

## Przykład z COMMIT

```sql
BEGIN;

UPDATE course.customers
SET acquisition_channel = 'referral'
WHERE customer_id = 8;

COMMIT;
```

Po `COMMIT` zmiana zostanie zapisana.

## Po co transakcje w praktyce

Transakcje są ważne, bo często jedna zmiana biznesowa wymaga kilku operacji.

Przykład:

- dodajesz klienta,
- dodajesz jego zamówienie,
- dodajesz pozycje tego zamówienia.

Jeśli część operacji się uda, a część nie, dane mogą zostać w niespójnym stanie.

Transakcja pozwala powiedzieć:

```text
Albo wszystko się uda, albo wszystko zostanie cofnięte.
```

## ACID

Transakcje często opisuje się skrótem `ACID`.

Na tym etapie nie trzeba znać bardzo formalnej definicji, ale warto rozumieć
intuicję.

```text
A - Atomicity
C - Consistency
I - Isolation
D - Durability
```

## Atomicity

Atomicity oznacza:

```text
Albo wykonuje się cała transakcja, albo żadna jej część.
```

Przykład:

- dodajemy zamówienie,
- dodajemy pozycje zamówienia.

Jeżeli zamówienie się dodało, ale pozycje już nie, dane są niespójne.

Transakcja pozwala cofnąć całość.

## Consistency

Consistency oznacza, że po transakcji baza nadal powinna spełniać swoje reguły.

Przykład:

- `PRIMARY KEY` nadal jest unikalny,
- `FOREIGN KEY` nadal wskazuje istniejące rekordy,
- `NOT NULL` nadal nie pozwala na braki w wymaganych kolumnach.

## Isolation

Isolation oznacza, że równoległe transakcje nie powinny sobie przypadkowo
przeszkadzać.

W praktyce wiele osób albo procesów może jednocześnie pracować na bazie.
Izolacja pomaga bazie kontrolować, co jedna transakcja widzi z drugiej.

Na start wystarczy zapamiętać:

> Transakcja daje bazie ramę do bezpiecznej pracy, nawet gdy wiele rzeczy dzieje się naraz.

## Durability

Durability oznacza, że po `COMMIT` zmiany powinny być trwałe.

Jeżeli baza zatwierdziła transakcję, dane nie powinny zniknąć tylko dlatego, że
sesja użytkownika się zakończyła.

## Autocommit

W wielu narzędziach SQL działa tryb `autocommit`.

Oznacza to, że pojedyncze polecenie DML może zostać zatwierdzone automatycznie.

Przykład:

```sql
UPDATE course.orders
SET status = 'paid'
WHERE order_id = 1003;
```

Jeżeli narzędzie ma włączony autocommit, zmiana może zostać zapisana od razu.

Dlatego przy nauce bezpiecznie jest jawnie używać:

```sql
BEGIN;
-- zmiany testowe
ROLLBACK;
```

albo:

```sql
BEGIN;
-- zmiany docelowe
COMMIT;
```

## Transakcje w data engineeringu

W pipeline'ach danych transakcje pomagają uniknąć częściowo załadowanych danych.

Przykład:

```text
Pipeline ładuje orders i order_items.
Orders się zapisały.
Order_items padły w połowie.
```

Bez transakcji baza może zostać w stanie częściowym.

Z transakcją można powiedzieć:

```text
Jeżeli cały load się nie udał, cofnij wszystko.
```

To jest ważne, bo dane po pipeline'ie powinny być spójne i możliwe do zaufania.

## Najważniejsze rzeczy do zapamiętania

- `BEGIN` rozpoczyna transakcję.
- `COMMIT` zatwierdza zmiany.
- `ROLLBACK` cofa zmiany.
- Transakcja pomaga pracować bezpiecznie.
- Przy kilku powiązanych zmianach transakcja chroni spójność danych.
- `ACID` opisuje podstawowe cechy transakcji.
- Autocommit może zatwierdzać pojedyncze polecenia automatycznie.
- W data engineeringu transakcje chronią przed częściowo załadowanymi danymi.
