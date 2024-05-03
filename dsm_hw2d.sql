CREATE TABLE Orders
(
  orderid        INT          NOT NULL,
  custid         INT          NULL,
  empid          INT          NOT NULL,
  orderdate      TIMESTAMP     NOT NULL,
  requireddate   TIMESTAMP     NOT NULL,
  shippeddate    TIMESTAMP     NULL,
  shipperid      INT          NOT NULL,
  freight        MONEY        NOT NULL
    CONSTRAINT DFT_Orders_freight DEFAULT(0),
  shipname       VARCHAR(40) NOT NULL,
  shipaddress    VARCHAR(60) NOT NULL,
  shipcity       VARCHAR(15) NOT NULL,
  shipregion     VARCHAR(15) NULL,
  shippostalcode VARCHAR(10) NULL,
  shipcountry    VARCHAR(15) NOT NULL 
) PARTITION BY RANGE (orderdate);

CREATE TABLE orders_1 
PARTITION OF orders
FOR VALUES FROM ('2006-07-03 00:00:00.000') TO ('2007-02-05 00:00:00.000')
PARTITION BY LIST (shipcountry);

-- Partition for orders shipped to USA and UK
CREATE TABLE orders_1_usa_uk
PARTITION OF orders_1
FOR VALUES IN ('USA', 'UK');

-- Partition for orders shipped to Germany and Finland
CREATE TABLE orders_1_ger_fin
PARTITION OF orders_1
FOR VALUES IN ('Germany', 'Finland');


