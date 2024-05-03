-- Function to check if parents are not younger than their offspring
CREATE OR REPLACE FUNCTION check_parent_age()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Specimen S1
        JOIN Ancestry A ON S1.EID = A.Parent
        JOIN Specimen S2 ON A.EID = S2.EID
        WHERE S1.BirthDate < S2.BirthDate
    ) THEN
        RAISE EXCEPTION 'Has older offsprings, fix ancestries first.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to check parent age before inserting into Specimen table
CREATE TRIGGER check_parent_age_trigger
BEFORE INSERT ON Specimen
FOR EACH ROW
EXECUTE FUNCTION check_parent_age();

-- Trigger to check parent age before updating Specimen table
CREATE TRIGGER check_parent_age_trigger_update
BEFORE UPDATE ON Specimen
FOR EACH ROW
EXECUTE FUNCTION check_parent_age();

-- Trigger to check parent age before inserting into Ancestry table
CREATE TRIGGER check_parent_age_trigger_ancestry
BEFORE INSERT ON Ancestry
FOR EACH ROW
EXECUTE FUNCTION check_parent_age();

-- Trigger to check parent age before updating Ancestry table
CREATE TRIGGER check_parent_age_trigger_ancestry_update
BEFORE UPDATE ON Ancestry
FOR EACH ROW
EXECUTE FUNCTION check_parent_age();
