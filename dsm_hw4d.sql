ALTER TABLE orders
ADD COLUMN shippedbeforerequired BOOLEAN;


CREATE PROCEDURE hw4d_set_shipped()
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE orders
    SET shippedbeforerequired = CASE WHEN shippeddate <= requireddate THEN TRUE ELSE FALSE END;
END;
$$;