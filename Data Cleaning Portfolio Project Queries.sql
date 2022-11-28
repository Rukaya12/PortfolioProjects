# Cleaning Data in SQL Queries #






Select*

FromPortfolioProject.dbo.NashvilleHousing





## Standardize Date Format




SelectsaleDateConverted, CONVERT(Date,SaleDate)

From PortfolioProject.dbo.NashvilleHousing

UpdateNashvilleHousing
SETSaleDate =CONVERT(Date,SaleDate)



--If it doesn't Update properly


ALTERTABLENashvilleHousing
Add SaleDateConverted Date;


UpdateNashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------


## Populate Property Address data


Select*
FromPortfolioProject.dbo.NashvilleHousing


--Where PropertyAddress is null
order byParcelID



Selecta.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a

JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddressis null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID=b.ParcelID
	AND a.[UniqueID ] <>b.[UniqueID ]
Where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

## Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress
from my_First_portfolio_project..[Nashville house data cleaning ]


select  
SUBSTRING(PropertyAddress ,1, CHARINDEX( ',' , PropertyAddress  )-1 ) as PropertyFixedAddress
,SUBSTRING(PropertyAddress,  CHARINDEX( ',' , PropertyAddress  ) +1 , len (PropertyAddress))as PropertyFixedCity

from my_First_portfolio_project..[Nashville house data cleaning ]


alter table my_First_portfolio_project..[Nashville house data cleaning ] add PropertyFixedAddress varchar (250)
alter table my_First_portfolio_project..[Nashville house data cleaning ] add PropertyFixedCity varchar (250)


update my_First_portfolio_project..[Nashville house data cleaning ]
set PropertyFixedAddress = SUBSTRING(PropertyAddress ,1, CHARINDEX( ',' , PropertyAddress  )-1 )


update my_First_portfolio_project..[Nashville house data cleaning ]
set PropertyFixedCity = SUBSTRING(PropertyAddress,  CHARINDEX( ',' , PropertyAddress  ) +1 , len (PropertyAddress))as PropertyFixedCity


select *
from my_First_portfolio_project..[Nashville house data cleaning ]

-----------------------------------------------------------------------------------------------------------------------------------
## Breaking out CITY AND STATE into Individual Columns ( City, State) USING PARSENAME 




Select OwnerAddress
From my_First_portfolio_project..[Nashville house data cleaning ]




select
PARSENAME (REPLACE( OwnerAddress ,',','.') ,3)
,PARSENAME (REPLACE( OwnerAddress ,',','.') ,2)
,PARSENAME (REPLACE( OwnerAddress ,',','.') ,1)

from my_First_portfolio_project..[Nashville house data cleaning ]



alter table my_First_portfolio_project..[Nashville house data cleaning ]
add  OwnerAddressFixed varchar(250)


update my_First_portfolio_project..[Nashville house data cleaning ]
set OwnerStateFixed = PARSENAME (REPLACE( OwnerAddress ,',','.') ,3)


alter table my_First_portfolio_project..[Nashville house data cleaning ]
add OwnerCityFixed varchar(250)


update my_First_portfolio_project..[Nashville house data cleaning ]
set OwnerStateFixed = PARSENAME (REPLACE( OwnerAddress ,',','.') ,2)


alter table my_First_portfolio_project..[Nashville house data cleaning ] 
add OwnerStateFixed varchar(250)


update my_First_portfolio_project..[Nashville house data cleaning ]
set OwnerStateFixed = PARSENAME (REPLACE( OwnerAddress ,',','.') ,1)

select *
from my_First_portfolio_project..[Nashville house data cleaning ]



------------------------------------------------------------------------------------------------------------------------------

## Change Y and N to Yes and No in "Sold as Vacant" field



select distinct (SoldAsVacant),count (SoldAsVacant)
from my_First_portfolio_project..[Nashville house data cleaning ]
group by SoldAsVacant
order by 2


select SoldAsVacant
,case when  SoldAsVacant = 'N' then 'No'
       when SoldAsVacant = 'Y' then 'Yes'
	   else SoldAsVacant
	   end
from my_First_portfolio_project..[Nashville house data cleaning ]


update my_First_portfolio_project..[Nashville house data cleaning ]
set SoldAsVacant =  case when  SoldAsVacant = 'N' then 'No'
       when SoldAsVacant = 'Y' then 'Yes'
	   else SoldAsVacant
   end
   
   
   
-------------------------------------------------------------------------------------------------------------------------
## Remove Duplicates


WITH row_numCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 Sale_Date_converted,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From my_First_portfolio_project..[Nashville house data cleaning ]

	
)
Select *
From row_numCTE
Where row_num > 1


select *
from my_First_portfolio_project..[Nashville house data cleaning ]

-----------------------------------------------------------------------------------------------


## Delete Unused Columns



Select *
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE my_First_portfolio_project..[Nashville house data cleaning ]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate



