CREATE OR REPLACE FUNCTION hw5_get_shipping_info(p_shipname VARCHAR)
RETURNS TABLE (
    orderid INT,
    shipname VARCHAR(40),
    shipaddress VARCHAR(60),
    shipcity VARCHAR(15),
    shipcountry VARCHAR(15)
)
AS $$
BEGIN
    RETURN QUERY
    SELECT orders.orderid, orders.shipname, orders.shipaddress, orders.shipcity, orders.shipcountry
    FROM Orders
    WHERE orders.shipname = p_shipname;
END;
$$ LANGUAGE plpgsql;
