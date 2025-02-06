--QUERY1: Calculate total visit, pageview, transaction for Jan, Feb and March 2017 (order by month)
SELECT  FORMAT_DATE('%Y%m',PARSE_DATE('%Y%m%d',date)) month
      , COUNT(totals.visits) visits
      , SUM(totals.pageviews) pageviews
      , SUM(totals.transactions) transactions
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
WHERE _table_suffix BETWEEN '0101' AND '0331'
GROUP BY 1
ORDER BY 1


--QUERY2: Bounce rate per traffic source in July 2017 
--(Bounce_rate = num_bounce/total_visit) (order by total_visit DESC)
SELECT trafficSource.source source
      , COUNT(totals.visits) total_visits
      , SUM(totals.bounces) total_no_of_bounces
      , ROUND(((SUM(totals.bounces)/COUNT(totals.visits))*100),3) bounce_rate
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
GROUP BY 1 
ORDER BY 2 DESC


--QUERY3: Revenue by traffic source by week, by month in June 2017
SELECT 'Month' as time_type
      , FORMAT_DATE('%Y%m',PARSE_DATE('%Y%m%d',date)) time
      , trafficSource.source source
      , ROUND((SUM(product.productRevenue)/1000000),4) revenue
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
UNNEST (hits) hits,
UNNEST (hits.product) product
WHERE product.productRevenue IS NOT NULL
GROUP BY 1, 2, 3

UNION ALL

SELECT 'Week' as time_type
      , FORMAT_DATE('%Y%W',PARSE_DATE('%Y%m%d',date)) time
      , trafficSource.source source
      , ROUND((SUM(product.productRevenue)/1000000),4) revenue
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201706*`,
UNNEST (hits) hits,
UNNEST (hits.product) product
WHERE product.productRevenue IS NOT NULL
GROUP BY 1, 2, 3
ORDER BY 4 DESC

--QUERY 4: Average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017
WITH 
purchaser_data AS (
  SELECT
      FORMAT_DATE("%Y%m",PARSE_DATE("%Y%m%d",DATE)) month,
      (SUM(totals.pageviews)/COUNT(DISTINCT fullvisitorid)) avg_pageviews_purchase,
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
    ,UNNEST(hits) hits
    ,UNNEST(product) product
  WHERE _table_suffix BETWEEN '0601' AND '0731'
  AND totals.transactions>=1
  AND product.productRevenue IS NOT NULL
  GROUP BY month
),

non_purchaser_data AS (
  SELECT
      FORMAT_DATE("%Y%m",PARSE_DATE("%Y%m%d",DATE)) month,
      SUM(totals.pageviews)/COUNT(DISTINCT fullvisitorid) avg_pageviews_non_purchase,
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
      ,UNNEST(hits) hits
    ,UNNEST(product) product
  WHERE _table_suffix BETWEEN '0601' AND '0731'
  AND totals.transactions IS NULL
  AND product.productRevenue IS NULL
  GROUP BY month
)

SELECT
    pd.*,
    avg_pageviews_non_purchase
FROM purchaser_data pd
FULL JOIN non_purchaser_data USING(month)
ORDER BY pd.month;

--QUERY 5:  Average number of transactions per user that made a purchase in July 2017
SELECT
    FORMAT_DATE("%Y%m",PARSE_DATE("%Y%m%d",DATE)) month,
    SUM(totals.transactions)/COUNT(DISTINCT fullvisitorid) Avg_total_transactions_per_user
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
    ,UNNEST (hits) hits,
    UNNEST(product) product
WHERE  totals.transactions>=1
AND product.productRevenue IS NOT NULL
GROUP BY month;

--QUERY6: Average amount of money spent per session. Only include purchaser data in July 2017
SELECT  FORMAT_DATE('%Y%m',PARSE_DATE('%Y%m%d',date)) month
      , ROUND((SUM(product.productRevenue/1000000)/SUM(totals.visits)),2) as avg_revenue_by_user_per_visit
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
UNNEST (hits) hits,
UNNEST (hits.product) product
WHERE totals.transactions IS NOT NULL AND product.productRevenue IS NOT NULL
GROUP BY 1

--QUERY 7: Other products purchased by customers who purchased product "YouTube Men's Vintage Henley" in July 2017. 
--Output should show product name and the quantity was ordered.
WITH user_henley as (
SELECT DISTINCT fullVisitorId
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
      UNNEST (hits) hits,
      UNNEST (hits.product) product
WHERE product.v2ProductName IN ("YouTube Men's Vintage Henley")
AND product.productRevenue IS NOT NULL)

SELECT product.v2ProductName as other_purchased_products
      ,SUM(product.productQuantity) as quantity
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
      UNNEST (hits) hits,
      UNNEST (hits.product) product
INNER JOIN user_henley
USING (fullVisitorId)
WHERE product.v2ProductName NOT IN ("YouTube Men's Vintage Henley")
AND product.productRevenue IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC

--QUERY 8: Calculate cohort map from product view to addtocart to purchase in Jan, Feb and March 2017.
WITH
product_view AS (
  SELECT
    FORMAT_DATE("%Y%m", parse_date("%Y%m%d", DATE)) month,
    COUNT(product.productSKU) as num_product_view
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
  , UNNEST(hits) AS hits
  , UNNEST(hits.product) AS product
  WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170331'
  AND hits.eCommerceAction.action_type = '2'
  GROUP BY 1
),

add_to_cart AS (
  SELECT
    FORMAT_DATE("%Y%m", PARSE_DATE("%Y%m%d", DATE)) month,
    COUNT(product.productSKU) as num_addtocart
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
  , UNNEST(hits) AS hits
  , UNNEST(hits.product) AS product
  WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170331'
  AND hits.eCommerceAction.action_type = '3'
  GROUP BY 1
),

purchase AS(
  SELECT
    FORMAT_DATE("%Y%m", PARSE_DATE("%Y%m%d", DATE)) month,
    COUNT(product.productSKU) num_purchase
  FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
  , UNNEST(hits) AS hits
  , UNNEST(hits.product) AS product
  WHERE _TABLE_SUFFIX BETWEEN '20170101' AND '20170331'
  AND hits.eCommerceAction.action_type = '6'
  AND product.productRevenue IS NOT NULL   --must have this condition to make sure a revenue is not null
  GROUP BY 1
)

SELECT
    pv.*,
    num_addtocart,
    num_purchase,
    ROUND(num_addtocart*100/num_product_view,2) add_to_cart_rate,
    ROUND(num_purchase*100/num_product_view,2) purchase_rate
FROM product_view pv
LEFT JOIN add_to_cart a ON pv.month = a.month
LEFT JOIN purchase p ON pv.month = p.month
ORDER BY pv.month;