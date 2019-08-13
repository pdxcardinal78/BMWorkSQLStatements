Select Part,
PartDescription,
PartRevision,
/** b.InspectionSpecification_No,**/
b.InspectionSpecification_type,
a.Inspection_No,
/**b.Result as SelectedResult,
b.CalculatedResult as InspectionResult,**/
Name,
c.Description,
/** c.ExtendedDescription, **/
DisplayOrder as InspectedPartNumber,
a.Result as ItemResult,
InspectionValue,
a.PassingMinimum,
a.PassingMaximum,
a.LastDate
From uniPoint_CompanyH.dbo.PT_InspectionItem_Measurement a
Join uniPoint_CompanyH.dbo.PT_Inspection b
on a.Inspection_No = b.Inspection_No
Join uniPoint_CompanyH.dbo.PT_InspectionSpecification_Measurement c
on a.InspectionSpecificationMeasurementID = c.InspectionSpecificationMeasurementID
Where b.InspectionSpecification_type = 'First Article'
Order By Inspection_No, InspectedPartNumber, Name