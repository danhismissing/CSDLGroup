USE PHOTOBOOTHMANAGE 
go

--1. Tra cứu lịch sử các phiên chụp chi tiết của khách hàng
SELECT 
    ps.SessionId AS [Mã phiên chụp],
    p.FullName AS [Tên khách hàng],
    s.StoreName AS [Cửa hàng],
    b.BoothId AS [Mã buồng chụp],
    ps.SessionTime AS [Thời gian chụp],
    ps.Price AS [Tổng thanh toán]
FROM photo_session ps
JOIN customer c ON ps.CustomerId = c.CustomerId
JOIN person p ON c.CustomerId = p.PersonId
JOIN booth b ON ps.BoothId = b.BoothId
JOIN store s ON b.StoreId = s.StoreId
ORDER BY ps.SessionTime DESC;

--2. Thống kê doanh thu và số lượt chụp theo cửa hàng 
SELECT 
    s.StoreId AS [Mã cửa hàng],
    s.StoreName AS [Tên cửa hàng],
    COUNT(ps.SessionId) AS [Tổng số lượt chụp],
    ISNULL(SUM(ps.Price), 0) AS [Tổng doanh thu]
FROM store s
LEFT JOIN booth b ON s.StoreId = b.StoreId
LEFT JOIN photo_session ps ON b.BoothId = ps.BoothId
GROUP BY s.StoreId, s.StoreName
ORDER BY [Tổng doanh thu] DESC;

--3. Top khung hình được khách hàng in nhiều nhất
SELECT 
    f.FrameId AS [Mã khung],
    f.FrameName AS [Tên khung hình],
    f.Price AS [Đơn giá khung],
    SUM(a.NumberPrint) AS [Tổng số bản đã in]
FROM frame f
JOIN about a ON f.FrameId = a.FrameId
GROUP BY f.FrameId, f.FrameName, f.Price
ORDER BY [Tổng số bản đã in] DESC;

--4. Lọc danh sách các khung hình Collab đang còn hạn bản quyền
SELECT 
    f.FrameId AS [Mã khung],
    f.FrameName AS [Tên khung hình],
    cf.IPName AS [Thương hiệu hợp tác],
    f.Price AS [Giá phụ thu],
    cf.StartDate AS [Ngày bắt đầu],
    cf.EndDate AS [Ngày kết thúc]
FROM frame f
JOIN collab_frame cf ON f.FrameId = cf.FrameId
WHERE GETDATE() BETWEEN cf.StartDate AND cf.EndDate;

--5. Tra cứu danh sách khách hàng thân thiết (có điểm tích lũy cao)
SELECT 
    c.CustomerId AS [ID khách hàng],
    p.FullName AS [Họ và tên],
    p.PhoneNumber AS [Số điện thoại],
    c.RewardsPoint AS [Điểm tích lũy hiện tại]
FROM customer c
JOIN person p ON c.CustomerId = p.PersonId
WHERE c.RewardsPoint > 0
ORDER BY c.RewardsPoint DESC;

--6. Xem lịch phân công ca làm việc của nhân viên theo ngày
SELECT 
    w.WorkDate AS [Ngày làm việc],
    ws.ShiftId AS [Mã ca],
    ws.StartTime AS [Giờ bắt đầu],
    ws.EndTime AS [Giờ kết thúc],
    e.EmployeeId AS [Mã nhân viên],
    p.FullName AS [Tên nhân viên]
FROM works w
JOIN work_shift ws ON w.ShiftId = ws.ShiftId
JOIN employee e ON w.EmployeeId = e.EmployeeId
JOIN person p ON e.EmployeeId = p.PersonId
ORDER BY w.WorkDate DESC, ws.StartTime ASC;

--7.  Kiểm tra tình trạng hoạt động của các buồng chụp (Booth) tại từng cửa hàng
SELECT 
    s.StoreName AS [Tên cửa hàng],
    b.BoothId AS [Mã buồng],
    b.BackGroundColor AS [Màu phông nền],
    b.Status AS [Trạng thái hiện tại]
FROM booth b
JOIN store s ON b.StoreId = s.StoreId
ORDER BY s.StoreName, b.BoothId;

--8.  Lấy toàn bộ link tải ảnh/video kỹ thuật số của một phiên chụp cụ thể
SELECT 
    fd.SessionId AS [Mã phiên chụp],
    fd.FileNumber AS [Số thứ tự file],
    fd.FileType AS [Định dạng file],
    fd.FileSize AS [Dung lượng],
    fd.LinkDownload AS [Đường dẫn tải xuống]
FROM file_digital fd
WHERE fd.SessionId = 'SS01';

--9. Danh sách các cửa hàng và thông tin người quản lý tương ứng
SELECT 
    s.StoreId AS [Mã cửa hàng],
    s.StoreName AS [Tên cửa hàng],
    s.Address AS [Địa chỉ],
    e.EmployeeId AS [Mã quản lý],
    p.FullName AS [Tên quản lý],
    p.PhoneNumber AS [SĐT quản lý]
FROM store s
JOIN employee e ON s.ManagerId = e.EmployeeId
JOIN person p ON e.EmployeeId = p.PersonId;