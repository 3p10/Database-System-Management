CREATE OR REPLACE FUNCTION check_habitat() RETURNS TRIGGER AS $$
    DECLARE
        habitat_name TEXT;
        species_habitat TEXT;
        habitat_temp INTEGER;
        species_temp INTEGER;
    BEGIN
        habitat_name = (SELECT habitat FROM Habitat WHERE HID = NEW.HID);
        species_habitat = (SELECT Habitat FROM AnimalSpecies WHERE AID = NEW.AID);
        habitat_temp = (SELECT Temperature FROM Habitat WHERE HID = NEW.HID);
        species_temp = (SELECT Temperature FROM AnimalSpecies WHERE AID = NEW.AID);
        IF species_habitat like '%' || habitat_name || '%' THEN
            RAISE NOTICE 'Correct habitat';
        ELSE
            RAISE EXCEPTION 'Not the correct habitat';
        END IF;
        IF abs(habitat_temp - species_temp) > 7 THEN
            RAISE EXCEPTION 'The Temperature difference can kill animals';
        END IF;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER check_habitat_trigger
    BEFORE INSERT OR UPDATE ON Specimen
    FOR EACH ROW EXECUTE PROCEDURE check_habitat();


--check temperature
CREATE OR REPLACE FUNCTION check_habitat_temp() RETURNS TRIGGER AS $$
    DECLARE
        habitat_temp INTEGER;
        species_temp INTEGER;
    BEGIN
        habitat_temp = NEW.Temperature;
        IF EXISTS(SELECT * FROM AnimalSpecies JOIN Specimen ON AnimalSpecies.AID = Specimen.AID WHERE HID = NEW.HID AND abs(habitat_temp - Temperature) > 7) THEN
            RAISE EXCEPTION 'The Temperature difference can kill animals';
        END IF;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_habitat_temp_trigger
    BEFORE INSERT OR UPDATE ON Habitat
    FOR EACH ROW EXECUTE PROCEDURE check_habitat_temp();