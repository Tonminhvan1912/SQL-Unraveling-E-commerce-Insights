# [SQL] Unraveling E-commerce Insight
## 1. **Introduction**

Performed an analysis of e-commerce data utilizing SQL on Google BigQuery, extracting actionable insights to guide strategic business decisions and enhance overall performance.

## 2. **Dataset access**

The eCommerce dataset is stored in a public Google BigQuery dataset. To access the dataset, follow these steps:

- Log in to your Google Cloud Platform account and create a new project.
- Navigate to the BigQuery console and select your newly created project.
- In the navigation panel, select "Add Data" and then "Search a project".
- Enter the project ID **"bigquery-public-data.google_analytics_sample.ga_sessions"** and click "Enter".
- Click on the **"ga_sessions_"** table to open it.
## 3. **Exploring the Dataset**

In this project, I will write 08 query in Bigquery base on Google Analytics dataset

**Query 01: Calculate total visit, pageview, transaction for Jan, Feb and March 2017 (order by month)**

- SQL code

![Image](https://github.com/user-attachments/assets/3ee26b6e-687b-4bd9-99c0-68491db5548a)

- Query results

![Image](https://github.com/user-attachments/assets/be09a5ff-4598-43bc-b480-b1d08a8e3570)

**Query 02: Bounce rate per traffic source in July 2017 (Bounce_rate = num_bounce/total_visit) (order by total_visit DESC)**

- SQL code

![Image](https://github.com/user-attachments/assets/16e0212f-05c0-4cd0-8d46-88d2b00ee7aa)

- Query results

![Image](https://github.com/user-attachments/assets/2c2bebd0-d027-4ab6-8622-ded8073a645a)

**Query 3: Revenue by traffic source by week, by month in June 2017**

- SQL code

![Image](https://github.com/user-attachments/assets/a097be82-de46-46bc-9f33-b82277f427aa)

- Query results

![Image](https://github.com/user-attachments/assets/6ba42d05-8401-45f6-b1fa-67ba9eb40c78)

**Query 04: Average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017.**

- SQL code

![Image](https://github.com/user-attachments/assets/5fa0382b-bb7e-42d6-9788-3f700cea77d4)
![Image](https://github.com/user-attachments/assets/64cdf881-0a39-407e-bb2b-49ce5fc7a755)

- Query results

![Image](https://github.com/user-attachments/assets/a05cc530-bc25-4480-a271-6440009b4790)

**Query 5: Average number of transactions per user that made a purchase in July 2017**

- SQL code

![Image](https://github.com/user-attachments/assets/34c65aae-dba2-456f-a1cd-e890fd4ff1be)

- Query results

![Image](https://github.com/user-attachments/assets/57e0d23f-4c8c-435b-88fa-711cc5e6784f)

**Query 6: Average amount of money spent per session. Only include purchaser data in July 2017**

- SQL code

![Image](https://github.com/user-attachments/assets/50c5418d-1463-486a-95bb-94851bf899df)

- Query results

![Image](https://github.com/user-attachments/assets/1a013047-31a0-46c5-87cf-edaf89f0dee6)

**Query 7: Other products purchased by customers who purchased product "YouTube Men's Vintage Henley" in July 2017. Output should show product name and the quantity was ordered.**

- SQL code

![Image](https://github.com/user-attachments/assets/e999c7e4-f02a-4f99-bfae-8b7b6d6a089f)

- Query results

![Image](https://github.com/user-attachments/assets/dae0a718-2b00-4530-b761-7d5ce0ba9caa)

**Query 8: Calculate cohort map from product view to addtocart to purchase in Jan, Feb and March 2017.**

- SQL code

![Image](https://github.com/user-attachments/assets/73f15d48-69c3-4591-82fb-b6be708c52a2)
![Image](https://github.com/user-attachments/assets/39b95613-248f-4b29-9f24-71008d29c27f)

- Query results

![Image](https://github.com/user-attachments/assets/fe58d0f4-0d38-4f72-9446-04ad78886cb5)

## 4. **Insights**
- **Buyers** exhibited an increase in average page views from June (94.02) to July (124.24), indicating heightened interest and engagement with the products.
- **Non-buyers** also experienced a slight uptick in average page views, from June (316.87) to July (334.66), suggesting that even those not purchasing are exploring the offerings more thoroughly.
- "Google Sunglasses" was the most purchased item (20 units), demonstrating its popularity among customers who bought the "YouTube Men's Vintage Henley," indicating cross-selling opportunities.
- The **Add to Cart Rate** improved significantly from 28.47% in January to 37.29% in March, reflecting enhanced effectiveness in encouraging users to take action.
- The **Purchase Rate** also increased from 8.31% in January to 11.64% in March, indicating that not only are more users adding items to their carts, but a greater proportion are completing their purchases.

## 5. **Recommendations**
- Implement targeted marketing strategies to engage non-buyers through personalized email campaigns and retargeting ads featuring products they have viewed but not purchased.
- Utilize the data on other frequently purchased products to develop cross-selling strategies. For example, promote "Google Sunglasses" alongside "YouTube Men's Vintage Henley" in marketing materials and during the checkout process.
- Analyze the checkout funnel to identify any drop-off points. Simplifying the checkout process can help convert more users who have added items to their carts.
