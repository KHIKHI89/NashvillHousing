/*
Data Cleaning 

*/
 

 select * from PortfolioProject.dbo.NashvillHousing


 -- Standardize the sale date format

 select SaleDate, CONVERT(date,SaleDate)
 from PortfolioProject.dbo.NashvillHousing


 Alter Table NashvillHousing
 add SaleDateConverted Date

 Update NashvillHousing
 set SaleDateConverted= CONVERT(date , SaleDate)


 select SaleDateConverted from PortfolioProject.dbo.NashvillHousing


----------------------------------------------------------
-- Populate Property Address data

 select a.ParcelID , a.PropertyAddress , b.ParcelID , b.PropertyAddress , ISNULL(a.PropertyAddress , b.PropertyAddress)
 from PortfolioProject.dbo.NashvillHousing a 
 join PortfolioProject.dbo.NashvillHousing b 
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is Null

Update a
set PropertyAddress =  ISNULL(a.PropertyAddress , b.PropertyAddress)
 from PortfolioProject.dbo.NashvillHousing a 
 join PortfolioProject.dbo.NashvillHousing b 
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is Null

----------------------------------------------------------
---- Breaking out Address into Individual Columns (Address, City, State)

select a.PropertyAddress
from PortfolioProject.dbo.NashvillHousing a


select 
SUBSTRING(PropertyAddress  ,1, CHARINDEX(',' , PropertyAddress) -1) as ADRESS,
SUBSTRING(PropertyAddress  , CHARINDEX(',' , PropertyAddress) +1 , LEN(PropertyAddress)) as ADRESS
 from PortfolioProject.dbo.NashvillHousing 


 Alter Table NashvillHousing
 add PropertysplitAdrss varchar(255)

 Update PortfolioProject.dbo.NashvillHousing
 set PropertysplitAdrss = SUBSTRING(PropertyAddress  ,1, CHARINDEX(',' , PropertyAddress) -1)

 Alter Table NashvillHousing
 add PropertysplitCity varchar(255)

 Update PortfolioProject.dbo.NashvillHousing 
 set PropertysplitCity = SUBSTRING(PropertyAddress  , CHARINDEX(',' , PropertyAddress) +1 , LEN(PropertyAddress))


 select OwnerAddress from PortfolioProject.dbo.NashvillHousing 


 select 
 PARSENAME(Replace(OwnerAddress ,',','.') ,3),
 PARSENAME(Replace(OwnerAddress ,',','.') ,2),
 PARSENAME(Replace(OwnerAddress ,',','.') ,1)
 from PortfolioProject.dbo.NashvillHousing 


 Alter Table NashvillHousing
  add OwnerAdresssplitAdress varchar(255)

  
 Alter Table NashvillHousing
  add OwnerAdresssplitcity varchar(255)


  
 Alter Table NashvillHousing
  add OwnerAdresssplitstate varchar(255)


  update  PortfolioProject.dbo.NashvillHousing 
  set OwnerAdresssplitAdress= PARSENAME(Replace(OwnerAddress ,',','.') ,3)

    update  PortfolioProject.dbo.NashvillHousing 
  set OwnerAdresssplitcity= PARSENAME(Replace(OwnerAddress ,',','.') ,2)

    update  PortfolioProject.dbo.NashvillHousing 
  set OwnerAdresssplitstate= PARSENAME(Replace(OwnerAddress ,',','.') ,1)


  select * from PortfolioProject.dbo.NashvillHousing 


  --------------------------------------------------
  -- convert Y to Yes and N to No
  
  select Distinct (SoldAsVacant) 
from PortfolioProject.dbo.NashvillHousing 

select SoldAsVacant,
case 
       when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant ='N' then 'No'
       else SoldAsVacant 
end 
from PortfolioProject.dbo.NashvillHousing 

update PortfolioProject.dbo.NashvillHousing 
set SoldAsVacant = case 
       when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant ='N' then 'No'
       else SoldAsVacant 
end 


---------------------------------------- 
-- Remove Duplicates

with RowNumberCTE AS (
select * ,
    ROW_NUMBER() Over (
	Partition By ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by 
				   UniqueID 
				   ) row_num

from PortfolioProject.dbo.NashvillHousing 
)
select * 
from RowNumberCTE
where row_num > 1 
--order by PropertyAddress


--------------------------------------------------
-- delete unused columns 

Alter Table PortfolioProject.dbo.NashvillHousing
Drop Column OwnerAddress , PropertyAddress 

select * 
from  PortfolioProject.dbo.NashvillHousing

Alter Table PortfolioProject.dbo.NashvillHousing
Drop Column SaleDate