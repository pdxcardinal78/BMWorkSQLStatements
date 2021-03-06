/****** Script for SelectTopNRows command from SSMS  ******/
SELECT DISTINCT b.Result
	  ,Part
	  ,LEFT(PartDescription, CASE WHEN CHARINDEX(',' , PartDescription) - 1 < 0 THEN 0 ELSE CHARINDEX(',' , PartDescription) - 1 END)
      ,a.[InspectionSpecification_No]
      ,[Name]
      ,[DataType]
      ,a.[Description]
      ,[ExtendedDescription]
      ,[IsSpecification]
      ,[IsProcess]
      ,[InputType]
      ,[Required]
	  ,DocDetail
  FROM [uniPoint_CompanyH].[dbo].[PT_InspectionSpecification_Measurement] a
  Join [uniPoint_CompanyH].[dbo].[PT_InspectionItem_Measurement] b
  on a.InspectionSpecificationMeasurementID = b.InspectionSpecificationMeasurementID
  LEFT Join uniPoint_CompanyH.dbo.PT_InspectionSpecification c
  on a.InspectionSpecification_No = c.InspectionSpecification_No
  Where b.Result <> 'Pass' and b.Result <> 'UnDetermined'