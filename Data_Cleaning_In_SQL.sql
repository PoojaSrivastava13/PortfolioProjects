select * from PortfolicProject.nashvillehousing;

-- Standerdizing date format

update PortfolicProject.nashvillehousing SET SaleDate = STR_TO_DATE(SaleDate, '%M %d,%Y');
select SaleDate from PortfolicProject.nashvillehousing;

-- Populate Property Address Data

select * from PortfolicProject.nashvillehousing;

select a.parcelID,a.propertyaddress,b.parcelID, b.PropertyAddress,ifnull(a.propertyaddress,b.propertyaddress) 
from PortfolicProject.nashvillehousing a
join PortfolicProject.nashvillehousing b
on a.ParcelID=b.ParcelID and
a.UniqueID != b.UniqueID
where a.PropertyAddress is null;

update a
set a.PropertyAddress=ifnull(a.propertyaddress,b.propertyaddress) 
from PortfolicProject.nashvillehousing a
join PortfolicProject.nashvillehousing b
on a.ParcelID=b.ParcelID and
a.UniqueID != b.UniqueID
where a.PropertyAddress is null;

-- Breaking PropertyAddress and OwnerAddress into individual columns of Address,city and state

select * from PortfolicProject.nashvillehousing;

alter table PortfolicProject.nashvillehousing
add PropertySplitAddress nvarchar(100)
after PropertyAddress,
add PropertySplitCity nvarchar(100)
after PropertySplitAddress;

select substring(PropertyAddress, 1, instr(PropertyAddress,',') -1) as address
from PortfolicProject.nashvillehousing;

update PortfolicProject.nashvillehousing
set PropertySplitAddress = substring(PropertyAddress, 1, instr(PropertyAddress,',') -1);

update PortfolicProject.nashvillehousing
set PropertySplitCity = substring(PropertyAddress, instr(PropertyAddress,',') +1, length(propertyAddress));

select OwnerAddress from PortfolicProject.nashvillehousing;

select OwnerAddress,
substring_index(OwnerAddress, ',', 1) as OwnerAddress1,
substring_index(substring_index(OwnerAddress, ',', 2), ',', -1) as OwnerAddressState,
substring_index(OwnerAddress, ',', -1) as OwnerAddressState
from PortfolicProject.nashvillehousing;

alter table PortfolicProject.nashvillehousing
add column OwnerSplitAddress varchar(100)
after OwnerAddress,
add column OwnerSplitCity varchar(100)
after OwnerSplitAddress,
add column OwnerSplitState varchar(100)
after OwnerSplitCity;

Update PortfolicProject.nashvillehousing
set OwnerSplitAddress = substring_index(OwnerAddress, ',', 1);

Update PortfolicProject.nashvillehousing
set OwnerSplitCity = substring_index(substring_index(OwnerAddress, ',', 2), ',', -1);

Update PortfolicProject.nashvillehousing
set OwnerSplitState = substring_index(OwnerAddress, ',', -1);

-- change Yes as Y and No as N in 'SoldAsVacant' field

select distinct(SoldAsVacant), count(SoldAsVacant) 
from PortfolicProject.nashvillehousing
Group by SoldAsVacant;

select SoldAsVacant,
	 Case When SoldAsVacant = 'Y' then 'Yes'
	 When SoldAsVacant = 'N' then 'No'
     Else SoldAsVacant
	 End
from PortfolicProject.nashvillehousing;

update PortfolicProject.nashvillehousing
set SoldAsVacant =
	 Case When SoldAsVacant = 'Y' then 'Yes'
	 When SoldAsVacant = 'N' then 'No'
     Else SoldAsVacant
     End;

-- Deleting Duplicate Rows Using Intermediate Table

select * from PortfolicProject.duplicate_nashvillehousing;

create table PortfolicProject.duplicate_nashvillehousing like PortfolicProject.nashvillehousing;


insert into PortfolicProject.duplicate_nashvillehousing
select * from PortfolicProject.nashvillehousing
where parcelid in (select parcelid from (with rownumCTE as(
select *, row_number() over (
partition by ParcelID,
			 PropertyAddress,
			 SaleDate,
             LegalReference,
             OwnerName
) row_num 
from PortfolicProject.nashvillehousing)

select * from rownumCTE
where row_num > 1) a);


