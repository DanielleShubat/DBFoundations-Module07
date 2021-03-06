Danielle Shubat

March 2, 2021

Foundations of Databases & SQL Programming

Assignment 07

# User Defined Functions in SQL: An Overview
## Introduction
This paper will define User Defined Functions (UDF) and illustrate the range of analytical potential across the different types of functions in SQL. 
## UDFs in SQL
Functions provide a powerful took for users to perform complex data analysis and observation. More expansive than Select statements and View creations, Functions in SQL are collections of programming code that are either build in to the RDMS or can be custom created. A custom function is called a User Defined Function, or UDF.  UDFs are commonly used in reporting and ETL processing, whereby comparative data can be presented in a single table (reporting) or data within tables can be edited for ease of use (ETL processing) for example. Figure 1 provides the macro-level syntax structure of Functions in SQL.
<this is where I would insert the image if I could get the code right...>
Figure 1 Basic structure of SQL User Defined Function 
(((https://www.sqlshack.com/learn-sql-user-defined-functions/), 2021 (External Site))
## Scalar, Inline, and Multi-Statement Functions
### Scalar Functions
UDFs can be either Scalar or Tabular. Scalar functions always return a single value while Tabular functions return a set of values in a table. Furthermore, Tabular functions can be sub-categorized into Inline and Multi-Statement functions. 
Simply put, Scalar functions perform an operation on a set of data to return a calculated value. The syntax of Scalar functions dictates that the schema name be included (typically dbo.) and that a Begin and End statement be present. 
### Tabular Functions
Tabular Inline functions return a set of rows -much like a view- that present a set of data which meet specified parameters. Inline functions return the types of results that can also be viewed through a simple view creation or Scalar function and for that reason, Inline functions are not as frequently used. 
In contract to Inline functions, Tabular Multi-Statement functions perform advanced logic upon data to return either a single table or a set of tables. The creation of Multi-Statement functions must include more explicit parameters than Inline functions, including column names and value types. The benefit of Multi-Statement functions is in the name: multiple select statements can be associated with a single function. 
## Summary
Whether a single data point is needed based on a calculation, or a table of results needs to be reviewed, UDFs are a key tool for database query.  Scalar functions are simple statements that can be quickly created in order to return single data points while more extensive table and table collections can be created through Inline and Multi-Statement functions. 
