---- Staff Table Creation----
DROP TABLE Staff CASCADE CONSTRAINTS;
CREATE TABLE Staff (
    Staff_ID CHAR(3),
    Phone_Num VARCHAR2(10) NOT NULL,
    Salary NUMBER(10, 2),
    Email VARCHAR2(30) UNIQUE,
    CONSTRAINT pk_staff PRIMARY KEY (Staff_ID)
);


---- Customer Table Creation----
DROP TABLE Customer CASCADE CONSTRAINTS;
CREATE TABLE Customer (
    Customer_ID CHAR(4),
    Email VARCHAR2(30) UNIQUE,
    Phone_Num VARCHAR2(15) NOT NULL,
    Last_N VARCHAR2(15),
    First_N VARCHAR2(15) NOT NULL,
    City VARCHAR2(50),
    Zip_Code VARCHAR2(10),
    Street VARCHAR2(40),
    Staff_ID CHAR(3),
    CONSTRAINT pk_customer PRIMARY KEY (Customer_ID),
    CONSTRAINT fk_staff FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID)
);
---- Order_ Table Creation----
DROP TABLE Order_ CASCADE CONSTRAINTS;
CREATE TABLE Order_(
    Order_ID CHAR(3),
    Customer_ID CHAR(4),
    Order_Date DATE,
    Status VARCHAR2(15),
    Total_Price NUMBER(8, 2),
    CONSTRAINT pk_order PRIMARY KEY (Order_ID),
    CONSTRAINT fk_customer FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);
---- Product Table Creation----
DROP TABLE Product CASCADE CONSTRAINTS;
CREATE TABLE Product(
    Product_ID CHAR(2),
    Product_Type VARCHAR2(50),
    Price NUMBER(8, 2),
    CONSTRAINT pk_product PRIMARY KEY (Product_ID)
);
---- Order_Product Table Creation----
DROP TABLE Order_Product CASCADE CONSTRAINTS;
CREATE TABLE Order_Product (
    Order_ID CHAR(3),
    Product_ID CHAR(2),
    Quantity NUMBER(3),
    CONSTRAINT pk_order_product PRIMARY KEY (Order_ID, Product_ID),
    CONSTRAINT fk_order FOREIGN KEY (Order_ID) REFERENCES Order_(Order_ID),
    CONSTRAINT fk_product FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID)
);
---- Bill Table Creation----
DROP TABLE Bill CASCADE CONSTRAINTS;
CREATE TABLE Bill (
    Order_ID CHAR(3),
    Receipt_Number VARCHAR2(30),
    Total_Cost NUMBER(8, 2),
    Payment_Type VARCHAR2(50),
    Card_Info VARCHAR2(50),
    Staff_ID CHAR(3),
    CONSTRAINT pk_bill PRIMARY KEY (Order_ID, Receipt_Number),
    CONSTRAINT fk_bill_order FOREIGN KEY (Order_ID) REFERENCES Order_ (Order_ID),
    CONSTRAINT fk_bill_staff FOREIGN KEY (Staff_ID) REFERENCES Staff(Staff_ID)
);


-- Inserting data into the Staff table
INSERT INTO Staff VALUES ('S01', '050134567', 3300.00, 'fajrAlrubeaan@example.com');
INSERT INTO Staff VALUES ('S02', '0502345678', 3200.00, 'sadeemAlsubhi@example.com');
INSERT INTO Staff VALUES ('S03', '0503456789', 3100.00, 'shujonAlshehri@example.com');

-- Inserting data into the Customer table
INSERT INTO Customer VALUES ('C111', 'GhadiAldosari@ example.com', '0504567890', 'Aldosari', 'Ghadi', 'Riyadh', '12345', '123 Kawadir St', 'S01');
INSERT INTO Customer VALUES ('C121', 'GhedafArefein@example.com', '0505678900', 'Arefein', 'Ghedaf', 'Abha', '23456', '456 Sahaba St', 'S02');
INSERT INTO Customer VALUES ('C131', 'SalehAlotaibi@example.com', '0506789012', 'Alotaibi', 'Saleh', 'Dammam', '34567', '789 shabarqa St', 'S03');

-- Inserting data into the Order table
INSERT INTO Order_ VALUES ('O11', 'C111', TO_DATE('01-11-2024', 'DD-MM-YYYY'), 'Pending', 150.00);
INSERT INTO Order_ VALUES ('O12', 'C121', TO_DATE('15-11-2024', 'DD-MM-YYYY'), 'Completed', 200.00);
INSERT INTO Order_ VALUES ('O13', 'C131', TO_DATE('07-9-2024', 'DD-MM-YYYY'), 'Shipped', 175.00);

-- Inserting data into the Product table
INSERT INTO Product VALUES ('p1', 'Rose Bouquet', 50.00);
INSERT INTO Product VALUES ('p2', 'Tulip Arrangement', 75.00);
INSERT INTO Product VALUES ('p3', 'Lily Centerpiece', 60.00);

-- Inserting data into the Order_Product table
INSERT INTO Order_Product VALUES ('O11','p1', 2);
INSERT INTO Order_Product VALUES ('O12', 'p2', 5);
INSERT INTO Order_Product VALUES ('O13', 'p3', 10);

-- Inserting data into the Bill table
INSERT INTO Bill VALUES ('O11', 'R001', 150.00, 'Credit Card', '**** **** **** 1234', 'S01');
INSERT INTO Bill VALUES ('O12', 'R002', 200.00, 'Debit Card', '**** **** **** 5678', 'S02');
INSERT INTO Bill (Order_ID, Receipt_Number, Total_Cost, Payment_Type,Staff_ID) VALUES ('O13', 'R003', 175.00, 'Cash','S03');

SET LINESIZE 200;

-- Select all from all tables--
SELECT * FROM Staff;
SELECT * FROM Customer;
SELECT * FROM Order_;
SELECT * FROM Product;
SELECT * FROM Order_Product;
SELECT * FROM Bill;


-- Create Admin Role and User

DROP ROLE ADMIN_ROLE;
CREATE ROLE ADMIN_ROLE;
GRANT CONNECT, RESOURCE TO ADMIN_ROLE;
GRANT ALL PRIVILEGES TO ADMIN_ROLE;

DROP USER admin_user CASCADE;
CREATE USER admin_user IDENTIFIED BY admin123;
GRANT ADMIN_ROLE TO admin_user;


-- Create Manager Role and User

DROP ROLE MANAGER_ROLE;
CREATE ROLE MANAGER_ROLE;
GRANT CONNECT TO MANAGER_ROLE;
GRANT SELECT, INSERT, UPDATE ON Staff TO MANAGER_ROLE;
GRANT SELECT, INSERT, UPDATE ON Order_ TO MANAGER_ROLE;
GRANT SELECT, INSERT, UPDATE ON Product TO MANAGER_ROLE;

DROP USER manager_user CASCADE;
CREATE USER manager_user IDENTIFIED BY manager123;
GRANT MANAGER_ROLE TO manager_user;


-- Create Cashier Role and User

DROP ROLE CASHIER_ROLE;
CREATE ROLE CASHIER_ROLE;
GRANT CONNECT TO CASHIER_ROLE;
GRANT SELECT, INSERT ON Order_ TO CASHIER_ROLE;
GRANT SELECT ON Customer TO CASHIER_ROLE;

DROP USER CASHIER_USER CASCADE;
CREATE USER CASHIER_USER IDENTIFIED BY cashier123;
GRANT CASHIER_ROLE TO CASHIER_USER;



--query helps identify which users have been assigned which roles from the database’s role management system--
SELECT
    GRANTEE AS USERNAME,
    GRANTED_ROLE
FROM
    DBA_ROLE_PRIVS
WHERE
    GRANTED_ROLE IN ('ADMIN_ROLE', 'MANAGER_ROLE', 'CASHIER_ROLE')
    AND GRANTEE IN ('ADMIN_USER', 'MANAGER_USER', 'CASHIER_USER');

 
--query helps identify (privileges) for each role has on which tables in the database.--
SELECT grantee, table_name, privilege
FROM dba_tab_privs
WHERE grantee IN ('ADMIN_ROLE', 'MANAGER_ROLE', 'CASHIER_ROLE')
ORDER BY grantee, table_name;



---Create Index---

CREATE INDEX idx_customer_phone ON Customer(Phone_Num);

SELECT * FROM Customer WHERE Phone_Num = '0506789012';



--- Join Optimization---

SELECT DISTINCT c.*
FROM Customer c
JOIN Order_ o ON c.Customer_ID = o.Customer_ID
WHERE o.Status = 'Completed';



--Stored Procedure: UpdateProductStock
--Used by managers/admins to update product quantity (e.g., after a new stock delivery).
CREATE OR REPLACE PROCEDURE UpdateProductStock (
    p_product_id IN CHAR,
    p_added_quantity IN NUMBER
)
IS
BEGIN
    UPDATE Order_Product
    SET Quantity = Quantity + p_added_quantity
    WHERE Product_ID = p_product_id;  

END;
/

BEGIN
    UpdateProductStock('p3', 5);
END;
/
	--RUN
 SELECT * FROM Order_Product WHERE Product_ID = 'p3';
 



 --Function: GetStaffSalaryByIDv
 --Returns the salary of a staff member based on their ID.

CREATE OR REPLACE FUNCTION GetStaffSalaryByID_(
    p_staff_id IN CHAR
)
RETURN NUMBER AS
    staff_salary NUMBER(10,2);
BEGIN
    SELECT Salary INTO staff_salary
    FROM Staff
    WHERE Staff_ID = p_staff_id;
    
    RETURN staff_salary;
END;
/
   --RUN
 SELECT GetStaffSalaryByID_('S02') AS salaryByID from dual;
 


--Trigger: SetDefaultOrderStatus
--Automatically sets the order status to 'Pending' if it's not provided when a new order is inserted.

CREATE OR REPLACE TRIGGER SetDefaultOrderStatus
BEFORE INSERT ON Order_
FOR EACH ROW
BEGIN
 -- Check if the status is NULL
    IF :NEW.status IS NULL THEN
 -- Assign default value 'Pending' if NULL
        :NEW.status := 'Pending';
    END IF;
END;
/

-- List all triggers associated with the ORDER_ table for the current user
SELECT trigger_name, table_name, status
FROM user_triggers
WHERE table_name = 'ORDER_';
  --RUN
INSERT INTO Order_ (Order_ID, Order_Date) VALUES ('015',  TO_DATE('2025-04-11', 'YYYY-MM-DD'));
  --CHECK
SELECT * FROM Order_ WHERE Order_ID = '015';
