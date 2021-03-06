USE Sales
GO

-- Step #1
-- Train the book category prediction model:
DECLARE @model_name varchar(100) = '<model_name>';
EXECUTE dbo.train_book_category_visitor @model_name;
SELECT * FROM sales_models WHERE model_name = @model_name;
GO

-- Step #2
-- Predict the book category clicks for new users based on their pattern of 
-- visiting various categories in the web site
DECLARE @sales_model varbinary(max) = (SELECT model_native FROM sales_models WHERE model_name = '<model_name>');
SELECT p.book_category_Pred as book_click_prediction
	, w.college_education as [College Education]
	, w.clicks_in_1 AS [Home & Kitchen]
	, w.clicks_in_2 AS [Music]
	, w.clicks_in_3 AS [Books]
	, w.clicks_in_4 AS [Clothing & Accessories]
	, w.clicks_in_5 AS [Electronics]
	, w.clicks_in_6 AS [Tools & Home Improvement]
	, w.clicks_in_7 AS [Toys & Games]
	, w.clicks_in_8 AS [Movies & TV]
	, w.clicks_in_9 AS [Sports & Outdoors]
  FROM PREDICT(MODEL = @sales_model, DATA  = web_clickstreams_book_clicks as w) WITH ("book_category_Pred" float) as p
 WHERE p.book_category_Pred <> SIGN(w.clicks_in_category);
GO