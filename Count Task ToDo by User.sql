/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TaskUserID, TaskDescription, COUNT(TaskItemType) as Tasks
  FROM [uniPoint_CompanyH].[dbo].[PT_Todo]
  Where TaskStatus = 'Active'
  Group By TaskUserID, TaskDescription
  Order By TaskUserID