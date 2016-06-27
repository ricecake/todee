BEGIN;
    CREATE TABLE todee_user (
        id serial primary key,
        username text not null
    );
    CREATE TABLE calorie_entry (
        id serial primary key,
        entrant integer not null references todee_user(id),
        entry_time timestamp without time zone not null default now(),
        calories integer not null
    );
    CREATE TABLE weight_entry (
        id serial primary key,
        entrant integer not null references todee_user(id),
        entry_time timestamp without time zone not null default now(),
        weight integer not null
    );

    create or replace view user_daily as
        select
            u.id as entrant,
            date_trunc('day', c.entry_time) as entry_day,
            sum(c.calories) as total_calories,
            avg(w.weight) as average_weight
        from todee_user u
        left join calorie_entry c on c.entrant = u.id
        left join weight_entry  w on w.entrant = u.id
        where date_trunc('day', c.entry_time) = date_trunc('day', w.entry_time)
        group by u.id, date_trunc('day', c.entry_time);

        create index on calorie_entry (entry_time);
        create index on calorie_entry (entrant);
        create index on calorie_entry (calories);

        create index on weight_entry (entry_time);
        create index on weight_entry (entrant);
        create index on weight_entry (weight);


COMMIT;
