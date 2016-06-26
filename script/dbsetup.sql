BEGIN;

    CREATE TABLE user (
        id serial primary key,
        username text not null
    );
    CREATE TABLE entries (
        id serial primary key,
        date timestamp without timezone not null default now(),
        ---- Should this be a list of raw measurements with a view that aggregates to daily?
        calories integer not null,
        weight integer not null
    );

COMMIT;
