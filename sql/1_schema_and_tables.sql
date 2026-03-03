-- =#=#=##=== DROPS (Clean up existing structure) ===##=#=#=



-- Drop foreign keys first to avoid dependency errors
ALTER TABLE Address DROP CONSTRAINT Address_City;
ALTER TABLE Cafe DROP CONSTRAINT Cafe_Address;
ALTER TABLE Employee DROP CONSTRAINT Employee_Cafe;
ALTER TABLE Employee DROP CONSTRAINT Employee_Position;
ALTER TABLE Product DROP CONSTRAINT Product_Category;
ALTER TABLE Customer_Order DROP CONSTRAINT Order_Customer;
ALTER TABLE Customer_Order DROP CONSTRAINT Order_Employee;
ALTER TABLE Order_Item DROP CONSTRAINT Order_Item_Order;
ALTER TABLE Order_Item DROP CONSTRAINT Order_Item_Product;
ALTER TABLE Payment DROP CONSTRAINT Payment_Order;
ALTER TABLE Payment DROP CONSTRAINT Payment_Method_FK;
ALTER TABLE Order_History DROP CONSTRAINT History_Order;
ALTER TABLE Order_History DROP CONSTRAINT History_Status;
ALTER TABLE Product_Promotion DROP CONSTRAINT Promo_Product;
ALTER TABLE Product_Promotion DROP CONSTRAINT Promo_Promotion;
ALTER TABLE Shift DROP CONSTRAINT Shift_Employee;

-- Drop tables
DROP TABLE Address;
DROP TABLE Cafe;
DROP TABLE Category;
DROP TABLE City;
DROP TABLE Customer;
DROP TABLE Customer_Order;
DROP TABLE Employee;
DROP TABLE Order_History;
DROP TABLE Order_Item;
DROP TABLE Order_Status;
DROP TABLE Payment;
DROP TABLE Payment_Method;
DROP TABLE Position;
DROP TABLE Product;
DROP TABLE Product_Promotion;
DROP TABLE Promotion;
DROP TABLE Shift;


-- ==========================================
-- TABLES CREATION
-- ==========================================

CREATE TABLE City (
    ID integer NOT NULL,
    Name varchar2(40) NOT NULL,
    CONSTRAINT City_pk PRIMARY KEY (ID)
);

CREATE TABLE Address (
    ID integer NOT NULL,
    Street varchar2(40) NOT NULL,
    Building_Number varchar2(4) NOT NULL,
    City_ID integer NOT NULL,
    CONSTRAINT Address_pk PRIMARY KEY (ID)
);

CREATE TABLE Cafe (
    ID integer NOT NULL,
    Name varchar2(50) NOT NULL,
    Address_ID integer NOT NULL,
    CONSTRAINT Cafe_pk PRIMARY KEY (ID)
);

CREATE TABLE Position (
    ID integer NOT NULL,
    Name varchar2(40) NOT NULL,
    CONSTRAINT Position_pk PRIMARY KEY (ID)
);

CREATE TABLE Employee (
    ID integer NOT NULL,
    First_Name varchar2(30) NOT NULL,
    Last_Name varchar2(30) NOT NULL,
    Hire_Date date NOT NULL,
    Position_ID integer NOT NULL,
    Cafe_ID integer NOT NULL,
    CONSTRAINT Employee_pk PRIMARY KEY (ID)
);

CREATE TABLE Customer (
    ID integer NOT NULL,
    First_Name varchar2(30) NOT NULL,
    Last_Name varchar2(30) NOT NULL,
    Email varchar2(60) NOT NULL,
    Phone varchar2(9) NOT NULL,
    Points integer NOT NULL,
    CONSTRAINT Customer_pk PRIMARY KEY (ID)
);

CREATE TABLE Category (
    ID integer NOT NULL,
    Name varchar2(60) NOT NULL,
    CONSTRAINT Category_pk PRIMARY KEY (ID)
);

CREATE TABLE Product (
    ID integer NOT NULL,
    Name varchar2(60) NOT NULL,
    Price number(10,2) NOT NULL,
    Category_ID integer NOT NULL,
    CONSTRAINT Product_pk PRIMARY KEY (ID)
);

CREATE TABLE Promotion (
    ID integer NOT NULL,
    Description varchar2(150) NOT NULL,
    Start_Date date NOT NULL,
    End_Date date NOT NULL,
    CONSTRAINT Promotion_pk PRIMARY KEY (ID)
);

CREATE TABLE Product_Promotion (
    Product_ID integer NOT NULL,
    Promotion_ID integer NOT NULL,
    Discount_Percentage number(5,2) NOT NULL,
    CONSTRAINT Product_Promotion_pk PRIMARY KEY (Product_ID, Promotion_ID)
);

CREATE TABLE Payment_Method (
    ID integer NOT NULL,
    Name varchar2(40) NOT NULL,
    CONSTRAINT Payment_Method_pk PRIMARY KEY (ID)
);

CREATE TABLE Order_Status (
    ID integer NOT NULL,
    Name varchar2(20) NOT NULL,
    CONSTRAINT Order_Status_pk PRIMARY KEY (ID)
);

CREATE TABLE Customer_Order (
    ID integer NOT NULL,
    Order_Date date NOT NULL,
    Customer_ID integer NOT NULL,
    Employee_ID integer NOT NULL,
    CONSTRAINT Customer_Order_pk PRIMARY KEY (ID)
);

CREATE TABLE Order_Item (
    Customer_Order_ID integer NOT NULL,
    Product_ID integer NOT NULL,
    Quantity integer NOT NULL,
    Unit_Price number(10,2) NOT NULL,
    CONSTRAINT Order_Item_pk PRIMARY KEY (Customer_Order_ID, Product_ID)
);

CREATE TABLE Payment (
    ID integer NOT NULL,
    Customer_Order_ID integer NOT NULL,
    Amount number(10,2) NOT NULL,
    Payment_Method_ID integer NOT NULL,
    CONSTRAINT Payment_pk PRIMARY KEY (ID)
);

CREATE TABLE Order_History (
    ID integer NOT NULL,
    Customer_Order_ID integer NOT NULL,
    New_Status integer NOT NULL,
    Change_Time timestamp NOT NULL,
    CONSTRAINT Order_History_pk PRIMARY KEY (ID)
);

CREATE TABLE Shift (
    ID integer NOT NULL,
    Employee_ID integer NOT NULL,
    Shift_Start timestamp NOT NULL,
    Shift_End timestamp NOT NULL,
    CONSTRAINT Shift_pk PRIMARY KEY (ID)
);

-- ==========================================
-- FOREIGN KEYS
-- ==========================================

ALTER TABLE Address ADD CONSTRAINT Address_City FOREIGN KEY (City_ID) REFERENCES City (ID);
ALTER TABLE Cafe ADD CONSTRAINT Cafe_Address FOREIGN KEY (Address_ID) REFERENCES Address (ID);
ALTER TABLE Employee ADD CONSTRAINT Employee_Cafe FOREIGN KEY (Cafe_ID) REFERENCES Cafe (ID);
ALTER TABLE Employee ADD CONSTRAINT Employee_Position FOREIGN KEY (Position_ID) REFERENCES Position (ID);
ALTER TABLE Product ADD CONSTRAINT Product_Category FOREIGN KEY (Category_ID) REFERENCES Category (ID);
ALTER TABLE Customer_Order ADD CONSTRAINT Order_Customer FOREIGN KEY (Customer_ID) REFERENCES Customer (ID);
ALTER TABLE Customer_Order ADD CONSTRAINT Order_Employee FOREIGN KEY (Employee_ID) REFERENCES Employee (ID);
ALTER TABLE Order_Item ADD CONSTRAINT Order_Item_Order FOREIGN KEY (Customer_Order_ID) REFERENCES Customer_Order (ID);
ALTER TABLE Order_Item ADD CONSTRAINT Order_Item_Product FOREIGN KEY (Product_ID) REFERENCES Product (ID);
ALTER TABLE Payment ADD CONSTRAINT Payment_Order FOREIGN KEY (Customer_Order_ID) REFERENCES Customer_Order (ID);
ALTER TABLE Payment ADD CONSTRAINT Payment_Method_FK FOREIGN KEY (Payment_Method_ID) REFERENCES Payment_Method (ID);
ALTER TABLE Order_History ADD CONSTRAINT History_Order FOREIGN KEY (Customer_Order_ID) REFERENCES Customer_Order (ID);
ALTER TABLE Order_History ADD CONSTRAINT History_Status FOREIGN KEY (New_Status) REFERENCES Order_Status (ID);
ALTER TABLE Product_Promotion ADD CONSTRAINT Promo_Product FOREIGN KEY (Product_ID) REFERENCES Product (ID);
ALTER TABLE Product_Promotion ADD CONSTRAINT Promo_Promotion FOREIGN KEY (Promotion_ID) REFERENCES Promotion (ID);
ALTER TABLE Shift ADD CONSTRAINT Shift_Employee FOREIGN KEY (Employee_ID) REFERENCES Employee (ID);