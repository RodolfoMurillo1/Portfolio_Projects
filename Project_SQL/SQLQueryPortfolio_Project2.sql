/*

Cleaning Data in SQL Queries

*/

Select*
From Portfolio_Project..NashvilleHousing


------------------------------------------------------------------------------------------

--Standarize Date Format

Select saleDateConverted, CONVERT(Date,SaleDate)
From Portfolio_Project..NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

------------------------------------------------------------------------------------------

--Populate Property Address data

Select*
From Portfolio_Project..NashvilleHousing
--Where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From Portfolio_Project..NashvilleHousing	a
JOIN Portfolio_Project..NashvilleHousing	b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From Portfolio_Project..NashvilleHousing	a
JOIN Portfolio_Project..NashvilleHousing	b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]

------------------------------------------------------------------------------------------
--Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From Portfolio_Project..NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1 , CHARINDEX(',',PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress)) as Address
From Portfolio_Project..NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1 , CHARINDEX(',',PropertyAddress) -1 )

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress))

Select*
From Portfolio_Project..NashvilleHousing


Select OwnerAddress
From Portfolio_Project..NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
From Portfolio_Project..NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSliptAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSliptAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

ALTER TABLE NashvilleHousing
Add OwnerSliptCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSliptCity= PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousing
Add OwnerSlipState Nvarchar(255);

Update NashvilleHousing
SET OwnerSlipState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

Select*
From Portfolio_Project..NashvilleHousing

------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Portfolio_Project..NashvilleHousing
Group by SoldAsVacant
order by 2

Select Select SoldAsVacant
,CASE When SoldAsVacant = 'Y' THEN 'Yes'
	  When SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
	  END
From Portfolio_Project..NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	  When SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
	  END

------------------------------------------------------------------------------------------

--Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Portfolio_Project..NashvilleHousing
--order by ParcelID
)
Select*
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

Select*
From Portfolio_Project..NashvilleHousing





------------------------------------------------------------------------------------------


--Delete Unused Columns

Select*
From Portfolio_Project..NashvilleHousing

ALTER TABLE Portfolio_Project..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE Portfolio_Project..NashvilleHousing
DROP COLUMN SaleDate




















