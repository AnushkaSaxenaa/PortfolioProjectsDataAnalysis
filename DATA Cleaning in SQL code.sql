-- Cleaning Data in SQL Queries

Select *
FROM [NashvilleHousing ] 

--Standardize the Date Format

select SaleDateConverted, Convert(Date,SaleDate)
FROM [NashvilleHousing ]

Update [NashvilleHousing ]
SET SaleDate =  Convert(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update [NashvilleHousing ]
SET SaleDateConverted =  Convert(Date,SaleDate)




--Populate Property Address data

select * from [NashvilleHousing ]
--where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, 
       ISNULL (a.PropertyAddress,b.PropertyAddress)
FROM [NashvilleHousing ]  a 
join [NashvilleHousing ]  b 
  on a.ParcelID = b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
  WHERE a.PropertyAddress IS NULL


  Update a
  SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
  FROM [NashvilleHousing ]  a 
  join [NashvilleHousing ]  b 
  on a.ParcelID = b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
  WHERE a.PropertyAddress IS NULL

  --Breaking out Address into Individual Columns (Address, city, State)

  select PropertyAddress
  From [NashvilleHousing ]
  --where PropertyAddress is null
  --order by ParcelID

 SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update [NashvilleHousing ]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1,
       CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar (255);

Update [NashvilleHousing ]
SET PropertySplitCity =   SUBSTRING(PropertyAddress,
   CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


   --The PARSENAME function in SQL Server allows you to extract specific parts of an object 
   --name (such as a table name, column name, or database name) based on a specified delimiter.
   --It’s particularly useful when dealing with objects that have multiple parts separated by a delimiter (usually a dot "."). 
-- syntax: PARSENAME('object_name', object_piece)

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
  from [NashvilleHousing ]


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update [NashvilleHousing ]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar (255);

Update [NashvilleHousing ]
SET OwnerSplitCity =  PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar (255);

Update [NashvilleHousing ]
SET OwnerSplitState =  PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


select * from [NashvilleHousing ]





SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
from [NashvilleHousing ]
Group by SoldAsVacant
order by 2



select SoldAsVacant 
, case when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
  end
FROM [NashvilleHousing ]

Update [NashvilleHousing ]
set SoldAsVacant =
 case when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
  end


  --Remove Duplicates

WITH RowNumCTE AS (
  SELECT *,
      ROW_NUMBER() OVER(
	  PARTITION BY ParcelID,
	               PropertyAddress,
				   SalePrice,
				   SaleDate,
				   LegalReference
				   ORDER BY 
				       UniqueID
					   ) row_num

  FROM [NashvilleHousing ]
--  ORDER BY ParcelID
)
SELECT * FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress








--Delete Unused Columns



select * from [NashvilleHousing ]



ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate

