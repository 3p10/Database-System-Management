CREATE PROCEDURE hw4b_add_freight()
LANGUAGE plpgsql
AS $$
DECLARE
BEGIN
    UPDATE Orders
    SET freight = ROUND((freight::numeric * 1.1)::numeric, 2)::money;
END;
$$;