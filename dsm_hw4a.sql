CREATE PROCEDURE hw4a_add_days
(
    
    p_orderid IN INTEGER,
    p_custid IN INTEGER,
    p_days IN INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
BEGIN
    IF p_orderid IS NULL THEN
        UPDATE orders
        SET requireddate = requireddate + (p_days * INTERVAL '1 DAY')
        WHERE custid = p_custid;
    ELSE
        UPDATE orders
        SET requireddate = requireddate + (p_days * INTERVAL '1 DAY')
        WHERE orderid = p_orderid;
    END IF;
END;
$$;