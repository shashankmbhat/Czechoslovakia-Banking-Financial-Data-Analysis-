I am thrilled to announce the completion of my latest project, "The Retail Data Analysis Dashboard." 🎉 This comprehensive, automated retail analysis model allows clients to upload data in AWS ☁️ and receive real-time updates in Power BI. 🚀💼📊🔍 Gain valuable insights into customer buying patterns and seasonal trends effortlessly.

This fully functional automated Retail Analysis Model involves 6 major steps:

🔸 1st Step in Amazon Web Services (AWS):
✅ Created an AWS S3 bucket and seamlessly uploaded all raw files into the bucket.
✅ Implemented appropriate roles and policies, enabling secure access to the bucket and performing essential operations such as creating user-specific folders and uploading data. 📂💻

🔸 2nd Step in Snowflake (#SQL):
✅ Conducted table creation and established storage integration and staging procedures to establish a connection with AWS.
✅ Connected AWS S3 to Snowflake by creating a storage integration and pipe, facilitating continuous data upload tracking by automatically creating corresponding tables in Snowflake.
✅ Set up a snowpipe to recognize and ingest files from the external stage, copying the data into the existing table. ❄️🔗

🔸 3rd Step in #Jupyter_Notebook (#Python):
✅ Established a seamless connection between Snowflake and Jupyter Notebook to retrieve data from tables into separate DataFrames.
✅ Conducted Exploratory Data Analysis (#EDA), which involved data cleaning, modification, and in-depth analysis.
✅ Stored the cleaned data back into Snowflake using the snowflake-python package within the same existing schema from which the data was extracted from the S3 bucket. 📊🐍

🔸 4th Step in #Jupyter_Lab (#Python):
✅ Utilized the jupyter_scheduler and jupyterlab-scheduler to automate the EDA process and avoid repetitive commands, enabling scheduled refreshes in Jupyter Lab. ⏰🔄

🔸 5th Step in Snowflake (#SQL):
✅ Created a master table and implemented several Key Performance Indicators (KPIs) in Snowflake using the cleaned data. 📈🔑

🔸 6th Step in #PowerBI:
✅ Seamlessly connected and schedule reguler refresh of the cleaned data, master table, and KPIs from Snowflake to Power BI.
✅ Leveraged the power of #DAX (Data Analysis Expressions), measures, new columns, parameters, and more within Power BI to create an intuitive and insightful dashboard. 📊💡💻
