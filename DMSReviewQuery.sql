Select UserID,
SUM(CASE WHEN DATEDIFF(dd, Approval_Date, getdate()) < 7 THEN 1 ELSE 0 END) as Prev_7Days,
SUM(CASE WHEN Approved = 1 THEN 1 ELSE 0 END) as TotalCompleted,
SUM(CASE WHEN Approved = 0 THEN 1 ELSE 0 END) as Pending
FROM uniPoint_CompanyH.dbo.PT_SignOff
Where Type = 'DMSReview'
Group By UserID