CREATE OR REPLACE FUNCTION check_habitat_capacity()
RETURNS TRIGGER AS $$
DECLARE
    total_space_needed INTEGER;
    habitat_capacity INTEGER;
    additional_space_needed INTEGER;
BEGIN
    SELECT Size INTO habitat_capacity FROM Habitat WHERE HID = NEW.HID;

    SELECT COALESCE(SUM(SpaceRequirements), 0) INTO total_space_needed
    FROM AnimalSpecies AS ASpec
    JOIN Specimen AS S ON ASpec.AID = S.AID
    WHERE S.HID = NEW.HID;

    additional_space_needed := (SELECT SpaceRequirements FROM AnimalSpecies WHERE AID = NEW.AID);
    total_space_needed := total_space_needed + additional_space_needed;

    IF total_space_needed > habitat_capacity THEN
        RAISE WARNING '% Compound is overbooked by % / %', NEW.HID, total_space_needed, habitat_capacity;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_habitat_capacity_trigger
BEFORE INSERT OR UPDATE ON Specimen
FOR EACH ROW
EXECUTE FUNCTION check_habitat_capacity();
