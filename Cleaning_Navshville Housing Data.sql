/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (100) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [PortfolioProject].[dbo].[Nashville]

  ---2. Standardize SalesDate Format

  SELECT SaleDateConverted, CONVERT(date,SaleDate)
  FROM PortfolioProject..Nashville

  Alter Table Nashville ---to add a table to the end of an existing dataset
  Add SaleDateConverted Date;

 Update Nashville
  Set SaleDateConverted =CONVERT(date,SaleDate)



  --3. Populating Property Address

   SELECT PropertyAddress
  FROM PortfolioProject..Nashville
  WHERE PropertyAddress is null
  --- The code above shows that there are some missing PropertyAddress


   SELECT *
  FROM PortfolioProject..Nashville
  Order by ParcelID
  --- The result of this code shoes that properties which have the 
  --same parcelID also share the same Property Address

    --- Self joining to align the missing PropertyAddress with parcelID

   SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
  FROM PortfolioProject..Nashville a
  Join PortfolioProject..Nashville  b
  ON a.ParcelID =b.ParcelID
  AND a.[UniqueID ]<>b.[UniqueID ]
  Where a.PropertyAddress is null

  --- Replacing missing property address

  SELECT a.ParcelID,a.PropertyAddress,  b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
  FROM PortfolioProject..Nashville a
  Join PortfolioProject..Nashville  b
  ON a.ParcelID =b.ParcelID
  AND a.[UniqueID ]<>b.[UniqueID ]
  Where a.PropertyAddress is null


  UPDATE a
  SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
  FROM PortfolioProject..Nashville a
  Join PortfolioProject..Nashville  b
  ON a.ParcelID =b.ParcelID
  AND a.[UniqueID ]<>b.[UniqueID ]
  Where a.PropertyAddress is null



  ---4 Breaking down address into individual columns

   SELECT PropertyAddress
  FROM PortfolioProject..Nashville 

  --- removing the delimiter (,)
  SELECT
  SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
  SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
FROM PortfolioProject..Nashville 

Alter Table PortfolioProject.dbo.Nashville
Add PropertySplitAddress NvarChar(255);

Update PortfolioProject.dbo.Nashville
Set PropertySplitAddress =SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 

Alter Table PortfolioProject.dbo.Nashville
Add PropertySplitCity NvarChar(255);

Update PortfolioProject.dbo.Nashville
Set PropertySplitCity =SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))


  SELECT *
  FROM PortfolioProject..Nashville 
  
----5 Splitting Owners Address

Select
 PARSENAME(replace(OwnerAddress,',','.'),3),
  PARSENAME(replace(OwnerAddress,',','.'),2),
   PARSENAME(replace(OwnerAddress,',','.'),1)
FROM PortfolioProject..Nashville 

---adding new column to table
Alter Table PortfolioProject.dbo.Nashville
Add OwnerSplitAddress NvarChar(255);

Update PortfolioProject.dbo.Nashville
Set OwnerSplitAddress =PARSENAME(replace(OwnerAddress,',','.'),3)


Alter Table PortfolioProject.dbo.Nashville
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProject.dbo.Nashville
SET OwnerSplitCity = PARSENAME(replace(OwnerAddress,',','.'),2)



Alter Table PortfolioProject.dbo.Nashville
Add OwnerSplitState Nvarchar(255);

Update PortfolioProject.dbo.Nashville
SET OwnerSplitState = PARSENAME(replace(OwnerAddress,',','.'),1)

 SELECT 
  FROM PortfolioProject..Nashville 


  ---6 Correcting SoldasVacant from 'Y' and 'N' to 'Yes' ans 'No' 
  ---Checking the column
  Select Distinct(SoldAsVacant), Count(soldasVacant)
  From PortfolioProject.dbo.Nashville
  Group by SoldAsVacant
  Order by 2

  ---adding a conditional statement to change 'Y' and 'N' to 'Yes' ans 'No' 
  Select SoldAsVacant
  ,Case When  SoldAsVacant ='Y' Then 'Yes' 
       when SoldAsVacant ='N' Then 'No' 
	   Else SoldAsVacant
	   END
   From PortfolioProject.dbo.Nashville


   Update PortfolioProject..Nashville 
   SET SoldAsVacant= Case When  SoldAsVacant ='Y' Then 'Yes' 
       when SoldAsVacant ='N' Then 'No' 
	   Else SoldAsVacant
	   END

----7 Deleting Unused Columns

Select *
From PortfolioProject.dbo.Nashville

Alter Table PortfolioProject.dbo.Nashville
Drop Column TaxDistrict, OwnerAddress,PropertyAddress, 



Alter Table PortfolioProject.dbo.Nashville
Drop Column SaleDate
















