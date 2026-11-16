
create database PHOTOBOOTHMANAGE
go
use PHOTOBOOTHMANAGE

create table person(
PersonId nvarchar (50) primary key,
FullName nvarchar(50) not null,
Gender nvarchar(10) not null,
BirthDay date not null,
PhoneNumber char (10) 
);
go 
create table employee(
EmployeeId nvarchar(50) primary key,
Salary int not null
);
go
create table customer(
CustomerId nvarchar(50) primary key,
RewardsPoint int not null default 0
);
go
create table store(
StoreId nvarchar (50) primary key,
StoreName nvarchar (50) not null,
Address nvarchar (50) not null,
ManagerId nvarchar(50) not null
);
go

create table frame (
FrameId nvarchar(50) primary key,
FrameName nvarchar(50) not null,
Price int not null 
);
go

create table work_shift(
ShiftId nvarchar (50) primary key ,
StartTime time  not null,
EndTime time  not null
);
go
create table booth(
BoothId nvarchar (50) primary key ,
StoreId nvarchar (50) not null,
BackGroundColor nvarchar (50) not null,
Status nvarchar (50) not null
);
go

create table photo_session(
SessionId nvarchar(50) primary key,
SessionTime datetime  not null,
Price int not null,
CustomerId nvarchar (50) not null,
EmployeeId nvarchar(50) not null,
ShiftId nvarchar(50) not null,
BoothId nvarchar(50) not null,
PointUsed int not null default 0
);
go

create table about(
SessionId nvarchar (50) not null,
FrameId nvarchar (50) not null,
NumberPrint int  not null,
primary key (SessionId, FrameID)
);

go
create table collab_frame(
FrameID nvarchar(50) primary key ,
IPName nvarchar (50) not null,
StartDate date not null ,
EndDate date not null
);
go

create table basic_frame(
FrameId nvarchar (50) primary key,
PrimaryColor nvarchar(50) not null 
);
go

create table file_digital(
SessionId nvarchar (50) not null,
FileNumber nvarchar (50) not null,
FileType nvarchar(50) not null,
FileSize nvarchar(50) not null,
LinkDownload nvarchar(500) not null,
primary key (SessionId, FileNumber)
);
go

create table works(
EmployeeId nvarchar (50) not null,
ShiftId nvarchar (50) not null,
WorkDate date not null,
primary key (EmployeeId, ShiftId)
);
go

ALTER TABLE employee
add constraint FK_EmployeeId Foreign key (EmployeeId) references person (PersonId);
ALTER TABLE customer
add constraint FK_CustomerId Foreign key (CustomerId) references person (PersonId);
ALTER TABLE store
add constraint FK_ManagerId Foreign key (ManagerId) references employee (EmployeeId);
ALTER TABLE booth
add constraint FK_StoreId Foreign key (StoreId) references store (StoreId);
ALTER TABLE photo_session
add constraint FK_ShiftId Foreign key (ShiftId) references work_shift (ShiftId),
constraint FK_BoothId Foreign key (BoothId) references booth (BoothId),
constraint CustomerId Foreign key (CustomerId) references customer (CustomerId),
constraint F_EmployeeId Foreign key (EmployeeId) references employee (EmployeeId);
ALTER TABLE about
add constraint K_SessionId Foreign key (SessionId) references photo_session (SessionId),
constraint F_FrameId Foreign key (FrameId) references frame (FrameId);
ALTER TABLE collab_frame
add constraint FK_FrameId Foreign key (FrameId) references frame (FrameId);
ALTER TABLE basic_frame
add constraint _FrameId Foreign key (FrameId) references frame (FrameId);
ALTER TABLE file_digital
add constraint _SessionId Foreign key (SessionId) references photo_session (SessionId);
ALTER TABLE works
add constraint K_EmployeeId Foreign key (EmployeeId) references employee (EmployeeId),
constraint F_ShiftId Foreign key (ShiftId) references work_shift (ShiftId);


