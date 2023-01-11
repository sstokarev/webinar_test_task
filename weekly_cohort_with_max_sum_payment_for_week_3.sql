select
    argMax(first_payment_week, payment_per_week) as weekly_cohort_with_max_sum_payment_for_week_3
from (
    select
        toWeek(first_payment_date, 3) as first_payment_week,
        dateDiff('week', first_payment_date, payment_date) as cohort_payment_week,
        sum(payment) as payment_per_week
    from (
        select
            user_id,
            min(toDate(created)) as first_payment_date
        from
            webinar_raw_data
        group by
            user_id
        ) as first_payment_date
        inner join (
        select
            user_id,
            toDate(created) as payment_date,
            payment
        from
            webinar_raw_data
        ) as payment_date
        on first_payment_date.user_id = payment_date.user_id
    group by
        first_payment_week,
        cohort_payment_week
    order by
        first_payment_week,
        cohort_payment_week
    )
where
    cohort_payment_week = 2
;