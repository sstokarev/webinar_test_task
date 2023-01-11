select
    argMax(first_payment_month, monthly_retention) as monthly_cohort_with_max_retention_for_month_3
from (
    select
        toMonth(first_payment_date) as first_payment_month,
        dateDiff('month', first_payment_date, payment_date) as cohort_payment_month,
        uniq(user_id) as active_per_period,
        max(active_per_period) over(partition by first_payment_month) as cohort_size,
        active_per_period / cohort_size * 100 as monthly_retention
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
            toDate(created) as payment_date
        from
            webinar_raw_data
        ) as payment_date
        on first_payment_date.user_id = payment_date.user_id
    group by
        first_payment_month,
        cohort_payment_month
    order by
        first_payment_month,
        cohort_payment_month
    )
where
    cohort_payment_month = 2