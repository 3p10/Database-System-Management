CREATE PROCEDURE hw4c_round_freight()
LANGUAGE plpgsql
AS $$
DECLARE
BEGIN
    UPDATE orders
    SET freight = (ROUND((freight::numeric / 10)::numeric, 0) * 10)::money;
END;
$$;
