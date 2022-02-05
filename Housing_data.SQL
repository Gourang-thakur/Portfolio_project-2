----Cleaning Data in SQL -----
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
select*
from NashvilleHousing	

--standardized the date Format,update the row

select saledateconverted,CONVERT(date,saledate) 
from NashvilleHousing	

Update NashvilleHousing	
set SaleDate=CONVERT(date,saledate)

alter table NashvilleHousing
add saledateconverted date;

update NashvilleHousing	
set saledateconverted=CONVERT(date,saledate)

------------------------------------------------------------------------------------------------------------------------------------------------------
--populate property address data

select *
from NashvilleHousing	
--where PropertyAddress is null
order by 2

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyaddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID=b.ParcelID
and 
a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update 
a
set PropertyAddress = ISNULL(a.propertyaddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
on a.ParcelID=b.ParcelID
and 
a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

-------------------------------------------------------------------------------------------------------------------------------------------------------
--Breaking out address into indivisual columns(address,city,state



select PropertyAddress
from NashvilleHousing	
--where PropertyAddress is null

select 
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) AS address
,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) AS address
from NashvilleHousing	

alter table NashvilleHousing
add propertysplitaddress nvarchar(255);

update NashvilleHousing	
set propertysplitaddress =SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)

alter table NashvilleHousing
add propertysplitcity nvarchar(255);

update NashvilleHousing	
set propertysplitcity=SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

select*
from NashvilleHousing

select 
parsename(replace(owneraddress,',','.'),3),
parsename(replace(owneraddress,',','.'),2),
parsename(replace(owneraddress,',','.'),1)
from NashvilleHousing


alter table NashvilleHousing
add ownersplitaddress nvarchar(255);

update NashvilleHousing	
set ownersplitaddress = parsename(replace(owneraddress,',','.'),3)

alter table NashvilleHousing
add ownersplitcity nvarchar(255);

update NashvilleHousing	
set ownersplitcity=parsename(replace(owneraddress,',','.'),2)

alter table NashvilleHousing
add ownersplitstate nvarchar(255);

update NashvilleHousing	
set ownersplitstate =parsename(replace(owneraddress,',','.'),1)

------------------------------------------------------------------------------------------------------------------------------------------------------

--Change y and n to yes and no in "sold and vacent" field 


select distinct (SoldAsVacant), count (SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant,
case when SoldAsVacant ='y' then 'Yes'
     when SoldAsVacant ='n' then 'No'
    else SoldAsVacant 
	end
from NashvilleHousing


update NashvilleHousing
set SoldAsVacant =
case when SoldAsVacant ='y' then 'Yes'
     when SoldAsVacant ='n' then 'No'
    else SoldAsVacant 
	end
from NashvilleHousing



---------------------------------------------------------------------------------------------------------------------------------------------------------------
--Remove Duplicate


with RowNumCTE AS(
select *,
   ROW_NUMBER() over (
   partition by parcelid,
                 propertyaddress,
				 saleprice,
				 saledate,
				 legalreference
				 order by
				 uniqueid
				 )
				 row_num
from NashvilleHousing
---order by ParcelID
)
select *
from RowNumCTE
where row_num > 1
order by propertyaddress


------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Delete unused columns

select *
from NashvilleHousing

alter table NashvilleHousing
drop column owneraddress, taxdistrict, propertyaddress

alter table NashvilleHousing
drop column saledate 





