-- ================== SECTION 1: CHURN OVERVIEW & SEGMENTATION ==================

-- Q1. What is the overall churn rate across all customers?
SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM saas_customer_churn;

-- Q2. What is the churn rate by subscription plan?
SELECT
    subscription_plan,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM saas_customer_churn
GROUP BY subscription_plan
ORDER BY churn_rate_pct DESC;

-- Q3. What is the churn rate by billing cycle? Does monthly billing drive higher churn than annual?
SELECT
    billing_cycle,
    COUNT(*) AS total_customers,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM saas_customer_churn
GROUP BY billing_cycle
ORDER BY churn_rate_pct DESC;

-- Q4. What is the churn rate by company size and industry combined?
SELECT
    company_size,
    industry,
    COUNT(*) AS total_customers,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM saas_customer_churn
GROUP BY company_size, industry
ORDER BY churn_rate_pct DESC;

-- Q5. Which age group has the highest churn rate?
SELECT
    age_group,
    COUNT(*) AS total_customers,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM saas_customer_churn
GROUP BY age_group
ORDER BY churn_rate_pct DESC;

-- Q6. What is the churn rate across each customer lifecycle stage (New, Developing, Established, Loyal)?
SELECT
    customer_lifecycle,
    COUNT(*) AS total_customers,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM saas_customer_churn
GROUP BY customer_lifecycle
ORDER BY churn_rate_pct DESC;

-- Q7. What is the churn rate by revenue segment?
SELECT
    revenue_segment,
    COUNT(*) AS total_customers,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM saas_customer_churn
GROUP BY revenue_segment
ORDER BY churn_rate_pct DESC;


-- ================== SECTION 2: ENGAGEMENT & PRODUCT USAGE ==================

-- Q8. What is the average login frequency for churned vs. retained customers?
SELECT
    churn,
    ROUND(AVG(avg_login_days_per_month), 2) AS avg_login_days,
    ROUND(AVG(last_month_login_count), 2) AS avg_last_month_logins
FROM saas_customer_churn
GROUP BY churn;

-- Q9. Does customer engagement level (Daily / Occasional / Consistent / Rare Visitor) correlate with churn rate?
SELECT
    customer_engagement,
    COUNT(*) AS total_customers,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM saas_customer_churn
GROUP BY customer_engagement
ORDER BY churn_rate_pct DESC;

-- Q10. What is the average number of features used by churned vs. active customers?
SELECT
    churn,
    ROUND(AVG(features_used), 2) AS avg_features_used,
    ROUND(AVG(storage_usage_gb)::numeric, 2) AS avg_storage_usage_gb
FROM saas_customer_churn
GROUP BY churn;

-- Q11. Which API usage tier (Low / Medium / High) has the highest churn rate?
SELECT
    api_usage,
    COUNT(*) AS total_customers,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM saas_customer_churn
GROUP BY api_usage
ORDER BY churn_rate_pct DESC;

-- Q12. Do customers who don't use the mobile app churn at a higher rate than those who do?
SELECT
    mobile_app_usage,
    COUNT(*) AS total_customers,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM saas_customer_churn
GROUP BY mobile_app_usage
ORDER BY churn_rate_pct DESC;


-- ================== SECTION 3: SUPPORT & SATISFACTION ==================

-- Q13. What is the average number of support tickets and response time for churned vs. retained customers?
SELECT
    churn,
    ROUND(AVG(support_tickets), 2) AS avg_support_tickets,
    ROUND(AVG(avg_response_time_hours)::numeric, 2) AS avg_response_time_hrs
FROM saas_customer_churn
GROUP BY churn;

-- Q14. How does churn rate vary across support experience categories?
SELECT
    support_experience,
    COUNT(*) AS total_customers,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM saas_customer_churn
GROUP BY support_experience
ORDER BY churn_rate_pct DESC;

-- Q15. What is the average satisfaction rating and NPS score for churned vs. retained customers?
SELECT
    churn,
    ROUND(AVG(satisfaction_rating)::numeric, 2) AS avg_satisfaction,
    ROUND(AVG(nps_score), 2) AS avg_nps
FROM saas_customer_churn
GROUP BY churn;

-- Q16. Which customers are flagged for immediate outreach but haven't churned yet?
SELECT
    customer_id,
    customer_name,
    subscription_plan,
    avg_login_days_per_month,
    support_tickets,
    satisfaction_rating,
    retention_priority
FROM saas_customer_churn
WHERE churn = 'No'
  AND retention_priority = 'Immediate Outreach'
ORDER BY support_tickets DESC;


-- ================== SECTION 4: REVENUE IMPACT ==================

-- Q17. What is the total revenue lost to churned customers?
SELECT
    ROUND(SUM(total_revenue)::numeric, 2) AS total_revenue_lost
FROM saas_customer_churn
WHERE churn = 'Yes';

-- Q18. What is the average monthly fee for churned vs. retained customers, broken down by subscription plan?
SELECT
    subscription_plan,
    churn,
    ROUND(AVG(monthly_fee)::numeric, 2) AS avg_monthly_fee,
    COUNT(*) AS total_customers
FROM saas_customer_churn
GROUP BY subscription_plan, churn
ORDER BY subscription_plan, churn;

-- Q19. Which revenue segment contributes the most total revenue, and what percentage of that segment has churned?
SELECT
    revenue_segment,
    ROUND(SUM(total_revenue)::numeric, 2) AS total_segment_revenue,
    ROUND((SUM(total_revenue) * 100.0 / (SELECT SUM(total_revenue) FROM saas_customer_churn))::numeric, 2) AS pct_of_total_revenue,
    ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM saas_customer_churn
GROUP BY revenue_segment
ORDER BY total_segment_revenue DESC;

-- Q20. Which countries generate the most total revenue, ranked highest to lowest?
SELECT
    country,
    ROUND(SUM(total_revenue)::numeric, 2) AS total_revenue,
    RANK() OVER (ORDER BY SUM(total_revenue) DESC) AS revenue_rank
FROM saas_customer_churn
GROUP BY country;


-- ================== SECTION 5: CUSTOMER RISK SCORING AND RANKING ==================

-- Q21.Calculate churn rate per industry, then rank industries from highest to lowest churn.
WITH industry_churn AS (
    SELECT
        industry,
        COUNT(*) AS total_customers,
        SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
        ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
    FROM saas_customer_churn
    GROUP BY industry
)
SELECT
    industry,
    total_customers,
    churned_customers,
    churn_rate_pct,
    RANK() OVER (ORDER BY churn_rate_pct DESC) AS churn_rank
FROM industry_churn;

-- Q22.How does each customer's monthly fee compare to their plan's average fee?
SELECT
    customer_id,
    subscription_plan,
    monthly_fee,
    ROUND(AVG(monthly_fee) OVER (PARTITION BY subscription_plan)::numeric, 2) AS plan_avg_fee,
    ROUND((monthly_fee - AVG(monthly_fee) OVER (PARTITION BY subscription_plan))::numeric, 2) AS diff_from_plan_avg
FROM saas_customer_churn
ORDER BY subscription_plan, diff_from_plan_avg DESC;

-- Q23. Which churned customers had support tickets above the company-wide average — a "preventable churn" list?
SELECT
    customer_id,
    customer_name,
    support_tickets,
    avg_response_time_hours,
    churn_reason
FROM saas_customer_churn
WHERE churn = 'Yes'
  AND support_tickets > (SELECT AVG(support_tickets) FROM saas_customer_churn)
ORDER BY support_tickets DESC;

-- Q24. Which customers are in the top 10% by total revenue but have "Rare Visitor" engagement — high-value, low-engagement flight risks?
WITH revenue_rank AS (
    SELECT
        customer_id,
        customer_name,
        total_revenue,
        customer_engagement,
        churn,
        PERCENT_RANK() OVER (ORDER BY total_revenue DESC) AS revenue_pct_rank
    FROM saas_customer_churn
)
SELECT
    customer_id,
    customer_name,
    total_revenue,
    customer_engagement,
    churn
FROM revenue_rank
WHERE revenue_pct_rank <= 0.10
  AND customer_engagement = 'Rare Visitor'
ORDER BY total_revenue DESC;
