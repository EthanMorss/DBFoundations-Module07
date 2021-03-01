Ethan Morss
March 3, 2021
IT FDN 130 A Wi 21: Foundations of Databases & SQL
Assignment 07

# User Defined Functions - A Brief Summary

## Introduction

This document will explore different types of User Defined Functions (UDF) and how they differ from each other.

## Expanding Analytical Possibilities

In SQL you use a User Defined Function when you need to interact with your data actively and perform complex operations.  While Select statements and saved Views give the user an opportunity to sort and cull results to meet specific needs, UDFs can be much more complicated and offer a broader set of tools.  With built in functions we are able to create sophisticated Select statements and Views but we can save UDFs and make larger statements that can return more information, and amplify the powers of built in beyond Select and View. 

## Types of UDFs

There are two basic types of UDFs Scalar, and Tabular.  A scalar function can accept any number of parameters and returns a single value, a Tabular Function can return one or more tables.  There are two basic subsets of Tabular Functions, inline and Multi-Statement Functions.  Although Functions are more powerful than views, they are limited in that other software, such as Excel and Tableau, can’t see Functions but can see views.

## Scalar Functions

A Scalar Function returns a single value, it inspires memories of old algebra classes in high school, a value is plugged into a preexisting expression, and a single value is returned.  Strangely Scalar Functions require Begin and End in the syntax, tabular Functions do not.  A scalar function does not produce an array or a complex structure of values.

## Tabular Functions

### Inline Function

From a syntactic perspective, an Inline Function looks much like a View with the key difference that the view does not take a parameter and the function requires one.  In practice, the Inline Function calls on an existing table to perform some operation with the parameter; it works this parameter through some logical operations performed by combined statements, but ultimately returns a set of rows.  It is a valuable tool, but for its complexity, it might be better to use a view, as a view can sometimes accomplish the same result of an Inline Function.

### Multi-Statement Function

A Multi-Statement Function is more complicated than an inline function and allows for more complicated logic to be performed.  The multi-statement function requires a table be defined as if you are creating a table from scratch, it wants columns names, and value types defined.  Depending on the logic performed, it could return one or more tables. 

### Limitations of Table-Valued Functions

Table-Values functions have limitations.  You cannot insert delete or update permanent tables with a function.  Functions do not call normal stored procedures but can call extended stored procedures and other functions.  Functions cannot use certain non-deterministic system functions.   You can not use a temporary table with a function.  Lastly, you can not use a try-catch block in a user defined function.

## Summary 

It has been shown there are two types of UDF; Scalar and Tabular.  The scalar produces a single result, while the tabular produces a table.  Additionally, differences between the different types of Tabular Functions have been shown to aide in analyzing the substance of database.  An Inline Function that sorts based on a parameter provided by the user, and returns a row of data, and a Multi-Statement Function that can produce one or more detailed tables.    
