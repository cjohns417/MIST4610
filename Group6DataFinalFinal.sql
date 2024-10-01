USE ha_chj41761;

INSERT INTO Customer (CustomerID, Fname, Lname, Phone, Email)
VALUES
  (1011, 'John', 'Doe', '123-456-7890', 'johndoe@example.com'),
  (1012, 'Jane', 'Smith', '987-654-3210', 'janesmith@example.com'),
  (1013, 'Michael', 'Johnson', '555-123-4567', 'michaeljohnson@example.com'),
  (1014, 'Emily', 'Davis', '444-987-6543', 'emilydavis@example.com'),
  (1015, 'David', 'Wilson', '333-789-0123', 'davidwilson@example.com');
  

  select * from Customer;
  
  INSERT INTO Saleperson (SalesmanID, Fname, Lname, Phone, Email, Dealership_Dealership_id)
VALUES
  (155, 'Alice', 'Johnson', '777-888-9999', 'alicejohnson@example.com', 11),
  (255, 'Bob', 'Smith', '666-555-4444', 'bobsmith@example.com', 21),
  (355, 'Charlie', 'Brown', '555-555-5555', 'charliebrown@example.com', 21),
  (455, 'David', 'Lee', '444-444-4444', 'davidlee@example.com', 31),
  (555, 'Emily', 'Wong', '333-333-3333', 'emilywong@example.com', 41);
  
  select * from Saleperson;
  
  INSERT INTO Sale (SaleID, SaleDate, SalePrice, Customer_CustomerID, Saleperson_SalesmanID, Car_CarID, Car_Saleperson_SalesmanID)
VALUES
  (1551, '2024-09-20', 2500.00, 1011, 155, 1001, 155),
  (2552, '2024-09-25', 3000.00, 1012, 255, 1002, 255),
  (3553, '2024-09-27', 2800.00, 1013, 155, 1003, 355),
  (4554, '2024-09-28', 3500.00, 1014, 255, 1004, 455),
  (5555, '2024-09-29', 2200.00, 1015, 155, 1005, 555);
  
 select * from Sale;
  
  INSERT INTO Car (CarID, Make, Model, Year, Mileage, VIN, Saleperson_SalesmanID)
VALUES
  (1001, 'Toyota', 'Camry', 2024, 10000, 'VIN12345', 155),
  (1002, 'Honda', 'Accord', 2023, 15000, 'VIN23456', 255),
  (1003, 'Ford', 'F-150', 2022, 20000, 'VIN34567', 355),
  (1004, 'Chevrolet', 'Silverado', 2021, 25000, 'VIN45678', 455),
  (1005, 'Nissan', 'Altima', 2020, 30000, 'VIN56789', 555);
  
  select * from Car;


  
  INSERT INTO Dealership (Dealership_id, Dealership_City, Dealership_State)
VALUES
  (11, 'Conyers', 'Georgia'),
  (21, 'Ball_Ground', 'Georgia'),
  (31, 'Phenix' , 'Alabama'),
  (41, 'Greenville', 'North Carolina'),
  (51, 'Orlando', 'Florida');
  
  select * from Dealership;
  
  INSERT INTO Warranty (Warranty_ID, Start_date, End_date, Warranty_Type, Car_CarID, Car_Saleperson_SalesmanID)
VALUES
  (10229, '2024-09-20', '2026-09-20', 'Comprehensive', 1001, 155),
  (20229, '2023-09-25', '2025-09-25', 'Basic', 1002, 255),
  (30229, '2022-09-27', '2024-09-27', 'Extended', 1003, 355),
  (40229, '2021-09-28', '2023-09-28', 'Bumper-to-Bumper', 1004, 455),
  (50229, '2020-09-29', '2022-09-29', 'Powertrain', 1005, 555);
  
  select * from Warranty;
  
  INSERT INTO Service (ServiceID, ServiceDate, ServiceType, ServiceCost, Car_CarID, Car_Saleperson_SalesmanID)
VALUES
  (11114, '2024-10-01', 'Oil Change', 50.00, 1001, 155),
  (21114, '2024-10-02', 'Tire Rotation', 30.00, 1002, 255),
  (31114, '2024-10-03', 'Brake Inspection', 20.00, 1003, 355),
  (41114, '2024-10-04', 'Battery Check', 15.00, 1004, 455),
  (51114, '2024-10-05', 'Wiper Blade Replacement', 10.00, 1005, 555);
  
  select * from Service;
  
ALTER TABLE Saleperson
ADD CONSTRAINT fk_Saleperson_Dealership
FOREIGN KEY (Dealership_id) REFERENCES Dealership(Dealership_id);

-- Simple Queries ---
 
 -- How many cars did we sell?
SELECT COUNT(SaleID) AS TotalCarsSold FROM Sale;
 -- what is the average cost of services performed?
SELECT AVG(ServiceCost) AS AverageServiceCost FROM Service;
 -- How many customers are in our database?
 SELECT COUNT(CustomerID) AS TotalCustomers FROM Customer;
-- Show me the count of cars by their manufacturing year?
SELECT Year, COUNT(CarID) AS CarCount FROM Car GROUP BY Year;

-- Complex Queries --

-- Can you show the total sales amount for each salesperson, along with the number of cars they have sold?
SELECT Saleperson.Fname, Saleperson.Lname, COUNT(Sale.SaleID) AS CarsSold, SUM(Sale.SalePrice) AS TotalSales
FROM Saleperson, Sale
WHERE Saleperson.SalesmanID = Sale.Saleperson_SalesmanID
GROUP BY Saleperson.Fname, Saleperson.Lname;
-- Report each customer and the cars they purchased, including the sale price, make, and model.
SELECT Customer.Fname, Customer.Lname, SalePrice, Car.Make, Car.Model
FROM Customer
JOIN Sale ON Customer.CustomerID = Sale.Customer_CustomerID
JOIN Car ON Sale.Car_CarID = Car.CarID
ORDER BY Customer.Lname;
-- List the cars along with their warranty details, including start and end dates, and warranty type
SELECT Car.CarID, Car.Make, Car.Model, Warranty.Start_date, Warranty.End_date, Warranty.Warranty_Type
FROM Car
JOIN Warranty ON Car.CarID = Warranty.Car_CarID AND Car.Saleperson_SalesmanID = Warranty.Car_Saleperson_SalesmanID;
-- How many services have been completed by each salesperson, and what is the total service cost attributed to each?
SELECT Saleperson.Fname, Saleperson.Lname, COUNT(Service.ServiceID) AS TotalServicesCompleted, SUM(Service.ServiceCost) AS TotalServiceCost
FROM Service
JOIN Car ON Service.Car_CarID = Car.CarID AND Service.Car_Saleperson_SalesmanID = Car.Saleperson_SalesmanID
JOIN Saleperson ON Car.Saleperson_SalesmanID = Saleperson.SalesmanID
GROUP BY Saleperson.SalesmanID;
-- Which cars have been sold that have an active warranty?
SELECT Car.Make, Car.Model, Car.Year, Sale.SaleDate, Sale.SalePrice
FROM Sale
JOIN Car ON Sale.Car_CarID = Car.CarID AND Sale.Car_Saleperson_SalesmanID = Car.Saleperson_SalesmanID
WHERE Car.CarID NOT IN (SELECT Warranty.Car_CarID 
FROM Warranty 
WHERE CURRENT_DATE > Warranty.End_date);
-- What is the average sale price of cars sold by each salesperson?
SELECT AVG(Sale.SalePrice) AS 'Average Sale Price', Saleperson.Fname, Saleperson.Lname
FROM Sale
JOIN Saleperson ON Sale.Saleperson_SalesmanID = Saleperson.SalesmanID
GROUP BY Saleperson.Lname, Saleperson.Fname;