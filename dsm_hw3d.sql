CREATE OR REPLACE FUNCTION check_parent_count() RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT COUNT(*) FROM Ancestry WHERE EID = NEW.EID) > 1 THEN
        RAISE EXCEPTION 'Offspring already has two parents.';
    ELSEIF NEW.Parent IS NOT NULL THEN
        IF (SELECT COUNT(*) FROM Ancestry JOIN Specimen ON Ancestry.Parent = Specimen.EID 
            WHERE Ancestry.EID = NEW.EID AND Specimen.Gender = (SELECT Gender FROM Specimen WHERE EID = NEW.Parent)) >= 1 THEN
            RAISE EXCEPTION 'Offspring already has this gender parent, fix ancestries first.';
        END IF;
    END IF;    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_parent_count_trigger
    BEFORE INSERT OR UPDATE ON Ancestry
    FOR EACH ROW EXECUTE FUNCTION check_parent_count();

CREATE OR REPLACE FUNCTION check_parent_specimen() RETURNS TRIGGER AS $$
BEGIN 
    IF NEW.Gender IS NULL THEN
        RAISE EXCEPTION 'Parent gender is set to NULL.';
    END IF;
    
    IF (SELECT COUNT(*) 
        FROM Ancestry AS A1 
        JOIN Ancestry AS A2 ON A1.EID = A2.EID 
        JOIN Specimen ON A2.Parent = Specimen.EID  
        WHERE A1.Parent = NEW.EID AND A2.Parent <> NEW.EID AND Specimen.Gender = NEW.Gender) >= 1 THEN
        RAISE EXCEPTION 'Offspring already has this gender parent, fix ancestries first.';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_parent_specimen_trigger
    BEFORE INSERT OR UPDATE ON Specimen
    FOR EACH ROW EXECUTE FUNCTION check_parent_specimen();
