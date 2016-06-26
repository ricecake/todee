BEGIN;

    CREATE TABLE user (
        id serial primary key,
        username text not null
    );
    CREATE TABLE entries (
        id serial primary key,
        date timestamp without timezone not null default now(),
        calories integer not null,
        weight integer not null
    );

COMMIT;
