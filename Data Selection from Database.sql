SELECT CAST(sched.Date AS DATE) AS [Date],
	   sales.[Total amount],
	   trans.[Count of transactions],
	   sales.[Total amount] / trans.[Count of transactions] AS [Average Bill Amount],
	   SUM([Students registered for the class]) * 0.8 AS [Students_count]  -- assuming student attendance on the class is 80%
FROM AcadScheduleSpring2024 sched
INNER JOIN (
			SELECT CAST(Date AS DATE) AS [Date],
			SUM([Price]) AS [Total amount]
			FROM SalesUniFood2024
			WHERE [???????] LIKE N'%???????????%' -- to select only the specific branch of UniFood
			AND [???????? ????] = N'?????' -- to exclude other types of sales like buffet services
			AND [Product_ID] IN (select [????]
								   from MenuFood
								) -- to include only the sales of food menu items of the specific branch of UniFood
			GROUP BY CAST(Date AS DATE)
		    ) sales ON sales.Date = sched.Date
INNER JOIN (
		    SELECT CAST(Date AS DATE) AS [Date],
				   COUNT([TransactionNumber]) as [Count of transactions]
			FROM Transactions
			WHERE [?????/??????] IN (N'????????? ?????? 1- ???????????', N'????????? ?????? 2 - ???????????')--, N'?????????? 1') -- to select only the transactions of the specific branch of UniFood
			GROUP BY CAST(Date AS DATE)
			) trans ON trans.Date = sched.Date
WHERE CAST(SUBSTRING([Starting hour of the class],
					 CHARINDEX(')',[Starting hour of the class]) - 11, 2) AS INT) < 18 -- the cafeteria UniFood operates from 10:00 till 18:00
	  AND [Starting hour of the class] NOT LIKE N'%?????%' -- excluding Sundays
	  AND [Online/Offline] = 'Offline' -- only in classroom attendance to be considered
	  AND [Building] IN ('E', 'F', 'G', 'H', 'T', 'S')
GROUP BY CAST(sched.Date AS DATE),
		 sales.[Total amount],
		 trans.[Count of transactions]
ORDER BY [Date]