Select * From uniPoint_CompanyH.dbo.PT_QC_Doc_Approval


Select Doc_Name, Doc_Num, t1.* From uniPoint_CompanyH.dbo.PT_SignOff t1
Join uniPoint_CompanyH.dbo.PT_QC_Doc t2
on SignoffTypeID = Doc_ID
Where SignoffType = 'DocControl' and Rejected = 1
Order By Doc_Num


Select Doc_Num, Comment From uniPoint_CompanyH.dbo.PT_SignOff t1
Join uniPoint_CompanyH.dbo.PT_QC_Doc t2
on SignoffTypeID = Doc_ID
Where SignoffType = 'DocControl' and Rejected = 1 and Doc_Status in ('Pending')
