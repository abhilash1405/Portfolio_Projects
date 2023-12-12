select * from housing;

--standardizing date format
select saledate,convert(date,saledate) from housing;

update housing
set saledate=convert(date,saledate)
--we are not able to update the column of date with new updated date
select * from housing;

alter table housing
add saledatenew date;

update housing 
set saledatenew=convert(date,saledate)
--converting sale date into saledatenew
--viewing updated date in housing table
select saledatenew from housing

alter table housing drop column saledate
select * from housing


--Populate Property Adress data
select propertyaddress from housing 
where propertyaddress is null

select propertyaddress from housing 
--where propertyaddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.propertyaddress)
from housing a
join housing b
on a.ParcelID=b.ParcelID and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress=ISNULL(a.PropertyAddress,b.propertyaddress)
from housing a
join housing b
on a.ParcelID=b.ParcelID and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

--Breaking out adress into individual Coulmns(Address,city,State)
select propertyaddress from housing

select 
substring(propertyaddress,1,charindex(',',propertyaddress)-1) as address,
substring(propertyaddress,charindex(',',propertyaddress)+1,len(propertyaddress)) as address
from housing

alter table housing
add propertysplitaddress varchar(255);

update housing
set propertysplitaddress=SUBSTRING(propertyaddress,1,CHARINDEX(',',propertyaddress)-1)

alter table housing
add propertysplitcity varchar(255);

update housing
set propertysplitcity=substring(propertyaddress,charindex(',',propertyaddress)+1,len(propertyaddress))

select * from housing

select owneraddress from housing

select
PARSENAME(replace(owneraddress,',','.'),3),
PARSENAME(replace(owneraddress,',','.'),2),
PARSENAME(replace(owneraddress,',','.'),1)
from housing

alter table housing
add ownersplitaddress varchar(255)

update housing
set ownersplitaddress=PARSENAME(REPLACE(owneraddress,',','.'),3)

alter table housing
add ownersplitcity varchar(255)
update housing
set ownersplitcity=PARSENAME(REPLACE(owneraddress,',','.'),2)

alter table housing
add ownersplitstate varchar(255)

update housing
set ownersplitstate=PARSENAME(REPLACE(owneraddress,',','.'),1)

select * from housing

--change y AND n TOYES AND NO IN "SOLD AS VACANT"
SELECT soldasvacant from housing

select soldasvacant,count(soldasvacant) from housing
group by soldasvacant
order by soldasvacant

select soldasvacant,
case
	when soldasvacant='Y' then 'Yes'
	when soldasvacant='N' then 'No'
	else soldasvacant
end
from housing

update housing
set SoldAsVacant=case
	when soldasvacant='Y' then 'Yes'
	when soldasvacant='N' then 'No'
	else soldasvacant
end
from housing

select soldasvacant from housing

select soldasvacant,count(soldasvacant) from housing
group by soldasvacant
order by soldasvacant

--remove duplicates

with dupcte as (
select *,ROW_NUMBER() over (partition by Parcelid,propertyaddress,saleprice,saledatenew,legalreference order by uniqueID) row_num
from housing)
select * from dupcte
where row_num>1

--delete unused column
select * from housing

alter table housing
drop column owneraddress,taxdistrict,propertyaddress

