BEGIN;

    CREATE TABLE user (
        id serial primary key,
        username text not null
    );
    CREATE TABLE entries (
        id serial primary key
    );

COMMIT;
