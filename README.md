# 📉 Superstore_Sales_Drop_Analysis




📘 Introduction


Declining sales can significantly impact business profitability, operational planning, and long-term growth.



This project analyzes Superstore sales data to identify the root causes of a noticeable sales decline, uncover underperforming segments, and evaluate customer behavior trends.


The analysis combines SQL-based data processing with Power BI dashboards to generate actionable business insights and support data-driven decision-making.



________________________________________


🎯 Objectives



The key objectives of this analysis are:



• To analyze overall sales trends and identify periods of decline



• To examine sales performance by category, sub-category, and region



• To identify key drivers behind the sales drop



• To evaluate customer purchasing behavior (new vs returning, order frequency, AOV)



• To provide actionable recommendations to improve sales performance




________________________________________


🗂️ Dataset and Context



One primary dataset was used:



Superstore Sales Dataset (sales data)



The dataset contains transactional-level information such as:



• Order Details: Order ID, Order Date, Ship Date



• Customer Information: Customer ID, Customer Name, Segment



• Geography: Country, State, Region



• Product Details: Category, Sub-Category, Product Name



• Sales Metrics: Sales Amount



Each row represents a unique product-level transaction within an order.



________________________________________



🧰Tools Used



The analysis was carried out using:



  SQL



o Data cleaning and preprocessing

o Sales trend and QoQ analysis

o Window functions (LAG, DENSE_RANK)

o CTEs and aggregations



Power BI


o Interactive dashboards

o KPI tracking (Sales, Orders, Customers, AOV)

o Category and regional performance visualization


CSV / Excel


o Source data storage


________________________________________


🧹 Data Preparation



The following data preparation steps were undertaken:



✔ Removed duplicate records using window functions



✔ Handled NULL and inconsistent values



✔ Standardized date formats for accurate time-based analysis



✔ Validated data integrity (e.g., Ship Date ≥ Order Date)



✔ Checked for outliers using IQR method (no significant anomalies found)



✔ Dropped unnecessary columns (Postal Code, temporary IDs)



✔ Prepared clean dataset for analysis




________________________________________



📊 Key Findings




📉 Sales dropped by approximately 15% in Q4, indicating a significant business concern



📦 Technology (-29%) and Office Supplies (-19%) were the primary contributors to the decline




📦 Certain sub-categories (Machines, Labels, Supplies) experienced sharp negative growth




🌎 West region showed the steepest decline (~ -98%), heavily impacting overall performance




💰 Customer base remained stable, but spending per order (AOV) dropped by ~29%




👥 Majority of customers are returning customers, indicating low new customer acquisition





________________________________________



📈 Dashboard Insights



The Power BI dashboard provides:



✔ Overall KPIs (Total Sales, Orders, Customers, AOV)



✔ Quarterly and monthly sales trends



✔ Category and sub-category performance breakdown



✔ Regional sales comparison



✔ Customer behavior insights (new vs returning, order frequency)



✔ Revenue decomposition (Customers × Orders × AOV)




________________________________________



💬 Conclusion and Insights



• The sales decline is primarily driven by reduced spending rather than loss of customers



• Category-level performance shows structural issues, especially in Technology and Office Supplies



• Regional imbalance, particularly poor performance in the West, significantly impacts total sales



• Customer acquisition is minimal, making the business overly dependent on existing customers



• Declining AOV suggests pricing, discounting, or product mix issues



________________________________________



💡 Strategic Recommendations




🚀 Improve High-Impact Categories:

Focus on reviving Technology and Office Supplies through pricing and promotions




💰 Increase Average Order Value (AOV):

Introduce bundling, cross-selling, and upselling strategies




🌍 Regional Strategy:

Investigate and address operational or demand issues in underperforming regions




📢 Customer Acquisition:

Invest in marketing campaigns to attract new customers




📦 Product Optimization:

Reduce dependency on consistently underperforming sub-categories



________________________________________



🎯 Expected Business Impact



• 10–15% recovery in declining sales segments



• Increase in Average Order Value (AOV) by 15–25%



• Improved regional performance balance



• Higher customer acquisition and revenue growth
