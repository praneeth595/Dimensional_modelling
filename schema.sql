-- ============================================================
-- Dimensional Modelling Star Schema
-- ============================================================

-- ======================
-- Dimension: Date
-- ======================
CREATE TABLE Dim_Date (
    Date_Key       INT PRIMARY KEY,       
    Full_Date      DATE NOT NULL,
    Year           INT NOT NULL,
    Quarter        INT,
    Month_Num      INT,
    Is_Weekend     CHAR(1)                
);

-- ======================
-- Dimension: Geography
-- ======================
CREATE TABLE Dim_Geography (
    Geo_Key       INT PRIMARY KEY AUTO_INCREMENT,
    Postal_Code   VARCHAR(20),
    City          VARCHAR(50),
    State         VARCHAR(50),
    Country       VARCHAR(50)
);

-- ======================
-- Dimension: Customer
-- ======================
CREATE TABLE Dim_Customer (
    Customer_Key  INT PRIMARY KEY AUTO_INCREMENT,
    Customer_NK   VARCHAR(50),          
    Full_Name     VARCHAR(100),
    Email         VARCHAR(100),
    Phone         VARCHAR(20),
    Geo_Key       INT,
    FOREIGN KEY (Geo_Key) REFERENCES Dim_Geography(Geo_Key)
);

-- ======================
-- Dimension: Store
-- ======================
CREATE TABLE Dim_Store (
    Store_Key     INT PRIMARY KEY AUTO_INCREMENT,
    Store_Code    VARCHAR(50),
    Store_Name    VARCHAR(100),
    Geo_Key       INT,
    FOREIGN KEY (Geo_Key) REFERENCES Dim_Geography(Geo_Key)
);

-- ======================
-- Dimension: Product
-- ======================
CREATE TABLE Dim_Product (
    Product_Key   INT PRIMARY KEY AUTO_INCREMENT,
    Product_Code        VARCHAR(50) UNIQUE,
    Product_Name  VARCHAR(100),
    Brand         VARCHAR(50),
    Category      VARCHAR(50),
    Subcategory   VARCHAR(50),
    
);

-- ======================
-- Dimension: Promotion
-- ======================
CREATE TABLE Dim_Promotion (
    Promotion_Key   INT PRIMARY KEY AUTO_INCREMENT,
    Promotion_Code  VARCHAR(50) UNIQUE,
    Description     VARCHAR(200),
    Start_Date_Key  INT,
    End_Date_Key    INT,
    FOREIGN KEY (Start_Date_Key) REFERENCES Dim_Date(Date_Key),
    FOREIGN KEY (End_Date_Key)   REFERENCES Dim_Date(Date_Key)
);

-- ======================
-- Fact: Sales
-- Grain: one row per order line
-- ======================
CREATE TABLE Fact_Sales (
    Sales_Key      INT PRIMARY KEY AUTO_INCREMENT,
    Date_Key       INT NOT NULL,
    Store_Key      INT NOT NULL,
    Product_Key    INT NOT NULL,
    Customer_Key   INT,
    Order_ID       VARCHAR(50) NOT NULL,
    Line_Number    INT NOT NULL,
    Quantity       DECIMAL(12,3),
    Unit_Price     DECIMAL(12,2),
    Discount_Amt   DECIMAL(12,2),
    Net_Amt        DECIMAL(12,2),

    FOREIGN KEY (Date_Key)    REFERENCES Dim_Date(Date_Key),
    FOREIGN KEY (Store_Key)   REFERENCES Dim_Store(Store_Key),
    FOREIGN KEY (Product_Key) REFERENCES Dim_Product(Product_Key),
    FOREIGN KEY (Customer_Key) REFERENCES Dim_Customer(Customer_Key),

    
);

-- ======================
-- Bridge: Sales ↔ Promotion (many-to-many)
-- ======================
CREATE TABLE Bridge_Sales_Promotion (
    Sales_Key      INT,
    Promotion_Key  INT,
    PRIMARY KEY (Sales_Key, Promotion_Key),
    FOREIGN KEY (Sales_Key) REFERENCES Fact_Sales(Sales_Key),
    FOREIGN KEY (Promotion_Key) REFERENCES Dim_Promotion(Promotion_Key)
);

-- ============================================================
-- End of Schema
-- ============================================================
