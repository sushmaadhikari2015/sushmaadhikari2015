-- the stored procedure "GetPatientMedicalHistory" retrieves various aspects of a patient's medical history in the healthcare domain. It takes a parameter @PatientID to identify the specific patient for whom the medical history is requested.

--The stored procedure retrieves the patient demographics from the "Patients" table. It then retrieves the patient's visits and associated diagnoses from the "Visits," "VisitDiagnoses," and "Diagnoses" tables. Next, it retrieves the patient's medications from the "Medications" and "PatientMedications" tables. It also retrieves the patient's lab results from the "LabResults" and "LabTests" tables. Furthermore, it fetches the patient's allergies from the "Allergies" and "PatientAllergies" tables. Finally, it retrieves the patient's immunizations from the "Immunizations" and "PatientImmunizations" tables.

--The stored procedure provides a comprehensive view of a patient's medical history by pulling data from multiple tables related to demographics, visits, diagnoses, medications, lab results, allergies, and immunizations.

--EXEC dbo.GetPatientDetails 101  -- calling SP 

CREATE PROCEDURE GetPatientDetails -- SP name 
    @PatientID INT  -- Paramter Name 
AS
BEGIN
    -- Declare variables
    DECLARE @PatientName VARCHAR(100)
    DECLARE @DateOfBirth DATE
    DECLARE @Gender VARCHAR(10)
    DECLARE @Diagnoses TABLE (  -- table variable 
        DiagnosisID INT,
        DiagnosisName VARCHAR(100),
		PatientID INT 
    )
    DECLARE @Medications TABLE ( -- table avariable 
        MedicationID INT,
        MedicationName VARCHAR(100),
        Dosage VARCHAR(50),
		PatientID INT 
    )
    DECLARE @LabResults TABLE (  -- table variable 
        LabID INT,
        LabName VARCHAR(100),
        ResultValue FLOAT,
        Unit VARCHAR(50),
		PatientID INT 
    )

    -- Get patient demographic details
    SELECT @PatientName = PatientName,
           @DateOfBirth = DateOfBirth,
           @Gender = Gender
    FROM Patients
    WHERE PatientID = @PatientID

    -- Get patient diagnoses
    INSERT INTO @Diagnoses (DiagnosisID, DiagnosisName,PatientID)
    SELECT DiagnosisID, DiagnosisName,PatientID
    FROM Diagnoses
    WHERE PatientID = @PatientID

    -- Get patient medications
    INSERT INTO @Medications (MedicationID, MedicationName, Dosage,PatientID)
    SELECT MedicationID, MedicationName, Dosage,PatientID
    FROM Medications
    WHERE PatientID = @PatientID

    -- Get patient lab results
    INSERT INTO @LabResults (LabID, LabName, ResultValue, Unit,PatientID)
    SELECT LabID, LabName, ResultValue, Unit,PatientID
    FROM LabResults
    WHERE PatientID = @PatientID

    -- Return the patient details along with diagnoses, medications, and lab results
    SELECT @PatientName AS PatientName,
           @DateOfBirth AS DateOfBirth,
           @Gender AS Gender,
           D.DiagnosisID,
           D.DiagnosisName,
           M.MedicationID,
           M.MedicationName,
           M.Dosage,
           LR.LabID,
           LR.LabName,
           LR.ResultValue,
           LR.Unit
    FROM @Diagnoses AS D
    INNER JOIN @Medications AS M ON D.PatientID = M.PatientID
    INNER JOIN @LabResults AS LR ON D.PatientID= LR.PatientID
END