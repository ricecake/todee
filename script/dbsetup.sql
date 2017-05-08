CREATE USER todee PASSWORD 'EXAMPLE#!';
CREATE DATABASE todee;

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

    CREATE OR REPLACE VIEW user_daily_summary AS
        SELECT
            u.id AS entrant,
            date_trunc('day', c.entry_time) AS entry_day,
            sum(c.calories) AS total_calories,
            w.weight AS last_weight
        FROM todee_user u
        LEFT JOIN calorie_entry c ON c.entrant = u.id
        LEFT JOIN (
            SELECT
                MAX(id) AS max_id,
                entrant
            FROM weight_entry
            GROUP BY entrant, date_trunc('day', entry_time)
        )  w_max ON w_max.entrant = u.id
        JOIN weight_entry w on w.id = w_max.max_id
        WHERE date_trunc('day', c.entry_time) = date_trunc('day', w.entry_time)
        GROUP BY u.id, date_trunc('day', c.entry_time);

        CREATE INDEX ON calorie_entry (entry_time);
        CREATE INDEX ON calorie_entry (entrant);
        CREATE INDEX ON calorie_entry (calories);

        CREATE INDEX ON weight_entry (entry_time);
        CREATE INDEX ON weight_entry (entrant);
        CREATE INDEX ON weight_entry (weight);


COMMIT;
