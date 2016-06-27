BEGIN;
    CREATE TABLE todee_user (
        id serial primary key,
        username text not null
    );
    CREATE TABLE calorie_entry (
        id serial primary key,
        user integer references todee_user(id),
        entry_time timestamp without timezone not null default now(),
        calories integer not null
    );
    CREATE TABLE weight_entry (
        id serial primary key,
        user integer references todee_user(id),
        entry_time timestamp without timezone not null default now(),
        weight integer not null
    );

    create or replace view user_daily as
        select u.user, date_trunc('day', c.entry_time), sum(c.calories), avg(w.weight)
        from user u
        join calorie_entry c on c.user = u.id
        join weight_entry  w on w.user = u.id
        where date_trunc('day', c.entry_time) = date_trunc('day', w.entry_time)
        group by u.user, date_trunc('day', c.entry_time);

COMMIT;
