-- Question group #1: --
-- What is the total sales? --
-- What is the total sales by vendor? --
-- What is the total sale of each product by vendor? --
SELECT DWPRODUCT.P_CODE, DWVENDOR.V_CODE, SUM(SALE_UNITS * SALE_PRICE) AS TOTAL_SALES
FROM DWDAYSALESFACT, DWPRODUCT, DWVENDOR
WHERE DWDAYSALESFACT.P_CODE = DWPRODUCT.P_CODE
AND DWPRODUCT.V_CODE = DWVENDOR.V_CODE
GROUP BY ROLLUP (DWVENDOR.V_CODE, DWPRODUCT.P_CODE)

-- Question group #2: --
-- What is the total sale of each product? --
-- What is the total sales of each month? --
-- What is the total sales for each month and product? --
SELECT DWPRODUCT.P_CODE, DWTIME.TM_MONTH, SUM(SALE_UNITS * SALE_PRICE) AS TOTAL_SALES
FROM DWDAYSALESFACT, DWTIME, DWPRODUCT
WHERE DWDAYSALESFACT.TM_ID = DWTIME.TM_ID
AND DWDAYSALESFACT.P_CODE = DWPRODUCT.P_CODE
GROUP BY CUBE (DWPRODUCT.P_CODE, DWTIME.TM_MONTH)