CREATE PROCEDURE GetPatientMedicalStatistics
    @PatientID INT
AS
BEGIN
    -- Variables to hold calculated statistics
    DECLARE @TotalVisits INT,
            @TotalLabTests INT,
            @TotalPrescriptions INT,
            @AverageLabTestsPerVisit FLOAT,
            @AveragePrescriptionsPerVisit FLOAT

    -- Retrieve total number of visits for the patient
    SELECT @TotalVisits = COUNT(*)
    FROM Visits
    WHERE PatientID = @PatientID

    -- Retrieve total number of lab tests for the patient
    SELECT @TotalLabTests = COUNT(*)
    FROM LabTests
    WHERE PatientID = @PatientID

    -- Retrieve total number of prescriptions for the patient
    SELECT @TotalPrescriptions = COUNT(*)
    FROM Prescriptions
    WHERE PatientID = @PatientID

    -- Calculate average lab tests per visit
    IF @TotalVisits > 0
        SET @AverageLabTestsPerVisit = CAST(@TotalLabTests AS FLOAT) / @TotalVisits
    ELSE
        SET @AverageLabTestsPerVisit = 0

    -- Calculate average prescriptions per visit
    IF @TotalVisits > 0
        SET @AveragePrescriptionsPerVisit = CAST(@TotalPrescriptions AS FLOAT) / @TotalVisits
    ELSE
        SET @AveragePrescriptionsPerVisit = 0

    -- Return the calculated statistics
    SELECT @TotalVisits AS TotalVisits,
           @TotalLabTests AS TotalLabTests,
           @TotalPrescriptions AS TotalPrescriptions,
           @AverageLabTestsPerVisit AS AverageLabTestsPerVisit,
           @AveragePrescriptionsPerVisit AS AveragePrescriptionsPerVisit
END