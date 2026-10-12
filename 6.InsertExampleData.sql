-- FITNESS DATABASE : INSERT DATA
USE FitnessDB;
GO

-- 1. ล้างข้อมูลเก่าและรีเซ็ต ID
DELETE FROM dbo.receipt_details;
DELETE FROM dbo.receipts;
DELETE FROM dbo.class_bookings;
DELETE FROM dbo.class_schedules;
DELETE FROM dbo.members;
DELETE FROM dbo.membership_types;
DELETE FROM dbo.instructors;
DELETE FROM dbo.fitness_classes;
GO

DBCC CHECKIDENT ('dbo.receipt_details', RESEED, 0);
DBCC CHECKIDENT ('dbo.receipts', RESEED, 0);
DBCC CHECKIDENT ('dbo.class_bookings', RESEED, 0);
DBCC CHECKIDENT ('dbo.class_schedules', RESEED, 0);
DBCC CHECKIDENT ('dbo.members', RESEED, 0);
DBCC CHECKIDENT ('dbo.membership_types', RESEED, 0);
DBCC CHECKIDENT ('dbo.instructors', RESEED, 0);
DBCC CHECKIDENT ('dbo.fitness_classes', RESEED, 0);
GO

-- 2. ข้อมูลประเภทแพ็กเกจสมาชิก (membership_types)
INSERT INTO dbo.membership_types 
    (type_name, price, duration_days)
VALUES 
    ('ราย 1 เดือน (Basic)', 1500.00, 30),
    ('ราย 3 เดือน (Basic)', 4000.00, 90),
    ('ราย 6 เดือน (Basic)', 7500.00, 180),
    ('ราย 1 ปี (Basic)', 14000.00, 365),
    ('ราย 1 เดือน (VIP)', 2500.00, 30),
    ('ราย 3 เดือน (VIP)', 7000.00, 90),
    ('ราย 6 เดือน (VIP)', 13000.00, 180),
    ('ราย 1 ปี (VIP)', 24000.00, 365),
    ('รายวัน (Day Pass)', 200.00, 1),
    ('แพ็กเกจนักศึกษา (รายเดือน)', 1000.00, 30);
GO

-- 3. ข้อมูลสมาชิก (members)
INSERT INTO dbo.members 
    (first_name, last_name, phone_number, email, membership_type_id, join_date, expire_date)
VALUES 
    ('สมชาย', 'ใจดี', '0811111111', 'somchai@email.com', 4, '2023-01-15', '2024-01-15'),
    ('สมหญิง', 'รักดี', '0822222222', 'somying@email.com', 8, '2023-03-10', '2024-03-10'),
    ('มานะ', 'อดทน', '0833333333', 'mana@email.com', 1, '2023-09-01', '2023-10-01'),
    ('ชูใจ', 'ใฝ่รู้', '0844444444', 'choojai@email.com', 5, '2023-08-15', '2023-09-14'),
    ('ปิติ', 'ยินดี', '0855555555', 'piti@email.com', 2, '2023-07-20', '2023-10-18'),
    ('วีระ', 'กล้าหาญ', '0866666666', 'weera@email.com', 10, '2023-09-05', '2023-10-05'),
    ('อรทัย', 'ใจบุญ', '0877777777', 'orathai@email.com', 3, '2023-05-01', '2023-10-28'),
    ('นที', 'สายน้ำ', '0888888888', 'natee@email.com', 7, '2023-06-15', '2023-12-12'),
    ('สุนี', 'มีโชค', '0899999999', 'sunee@email.com', 9, '2023-09-20', '2023-09-21'),
    ('กิตติ', 'พาณิชย์', '0900000000', 'kitti@email.com', 6, '2023-08-01', '2023-10-30');
GO

-- 4. ข้อมูลเทรนเนอร์ (instructors)
INSERT INTO dbo.instructors 
    (first_name, last_name, specialty)
VALUES 
    ('แจ็ค', 'นักกล้าม', 'Weight Training'),
    ('แอน', 'ยืดหยุ่น', 'Yoga'),
    ('ทอม', 'สายลุย', 'CrossFit'),
    ('เจนนี่', 'สายแดนซ์', 'Zumba'),
    ('ไมค์', 'หมัดเหล็ก', 'Boxing / Muay Thai'),
    ('ลิซ่า', 'หน้าท้องแบน', 'Pilates'),
    ('จอห์น', 'นักวิ่ง', 'Cardio / Treadmill'),
    ('ซาร่า', 'หุ่นฟิต', 'Body Pump'),
    ('เคน', 'กล้ามปู', 'Bodybuilding'),
    ('มารี', 'ใจเย็น', 'Stretching');
GO

-- 5. ข้อมูลคลาสเรียน (fitness_classes)
INSERT INTO dbo.fitness_classes 
    (class_name, description)
VALUES 
    ('Yoga Beginner', 'คลาสโยคะสำหรับผู้เริ่มต้น เน้นพื้นฐาน'),
    ('Advanced Zumba', 'คลาสเต้นซุมบ้าจังหวะเร็ว เผาผลาญแคลอรีสูง'),
    ('Muay Thai Fitness', 'คลาสมวยไทยเพื่อการออกกำลังกาย'),
    ('Pilates Core', 'คลาสพิลาทิสเน้นสร้างความแข็งแรงแกนกลางลำตัว'),
    ('Body Pump Intensity', 'คลาสยกน้ำหนักเข้าจังหวะเพลง'),
    ('CrossFit Challenge', 'คลาสครอสฟิตสุดโหด สร้างความอึด'),
    ('HIIT Blast', 'คลาสออกกำลังกายหนักสลับเบา เผาผลาญต่อเนื่อง'),
    ('Stretching Relax', 'คลาสยืดเหยียดกล้ามเนื้อ ลดอาการออฟฟิศซินโดรม'),
    ('Cycling Sprint', 'คลาสปั่นจักรยานในร่ม'),
    ('Abs Workout', 'คลาสเน้นสร้างหน้าท้องและซิกแพค');
GO

-- 6. ข้อมูลรอบตารางคลาส (class_schedules)
INSERT INTO dbo.class_schedules 
    (class_id, instructor_id, room_name, start_time, end_time, max_capacity)
VALUES 
    (1, 2, 'Room A', '2023-10-10 10:00:00', '2023-10-10 11:00:00', 20),
    (2, 4, 'Room B', '2023-10-10 17:00:00', '2023-10-10 18:00:00', 30),
    (3, 5, 'Boxing Area', '2023-10-10 18:30:00', '2023-10-10 19:30:00', 15),
    (4, 6, 'Room A', '2023-10-11 09:00:00', '2023-10-11 10:00:00', 20),
    (5, 8, 'Weight Room', '2023-10-11 19:00:00', '2023-10-11 20:00:00', 25),
    (6, 3, 'CrossFit Area', '2023-10-12 18:00:00', '2023-10-12 19:00:00', 15),
    (7, 7, 'Room C', '2023-10-12 07:00:00', '2023-10-12 08:00:00', 25),
    (8, 10, 'Room A', '2023-10-13 12:00:00', '2023-10-13 13:00:00', 20),
    (9, 7, 'Cycling Room', '2023-10-13 18:00:00', '2023-10-13 19:00:00', 20),
    (10, 1, 'Room B', '2023-10-14 17:30:00', '2023-10-14 18:30:00', 25);
GO

-- 7. ข้อมูลการจองคลาส (class_bookings)
INSERT INTO dbo.class_bookings 
    (member_id, schedule_id, booking_status, booking_date)
VALUES 
    (1, 1, 'Attended', '2023-10-09 10:30:00'),
    (2, 2, 'Confirmed', '2023-10-09 11:00:00'),
    (3, 3, 'Confirmed', '2023-10-09 14:15:00'),
    (4, 1, 'Cancelled', '2023-10-09 15:00:00'),
    (5, 5, 'Confirmed', '2023-10-10 09:00:00'),
    (6, 4, 'Confirmed', '2023-10-10 10:20:00'),
    (7, 7, 'Confirmed', '2023-10-11 08:30:00'),
    (8, 6, 'Confirmed', '2023-10-11 09:45:00'),
    (9, 9, 'Cancelled', '2023-10-12 10:00:00'),
    (10, 10, 'Confirmed', '2023-10-13 16:30:00');
GO

-- 8. ข้อมูลใบเสร็จรับเงิน (receipts)
INSERT INTO dbo.receipts 
    (member_id, receipt_date, total_amount, payment_method, payment_status, cashier_name)
VALUES 
    (1, '2023-01-15 10:00:00', 14000.00, 'Credit Card', 'Paid', 'Admin_Joy'),
    (2, '2023-03-10 11:30:00', 24000.00, 'Bank Transfer', 'Paid', 'Admin_Joy'),
    (3, '2023-09-01 14:00:00', 1500.00, 'PromptPay', 'Paid', 'Admin_Jane'),
    (4, '2023-08-15 09:15:00', 2500.00, 'Cash', 'Paid', 'Admin_Jane'),
    (5, '2023-07-20 18:45:00', 4000.00, 'Credit Card', 'Paid', 'Admin_Joy'),
    (6, '2023-09-05 17:20:00', 1000.00, 'PromptPay', 'Paid', 'Admin_Jane'),
    (7, '2023-05-01 13:10:00', 7500.00, 'Bank Transfer', 'Paid', 'Admin_Joy'),
    (8, '2023-06-15 16:00:00', 13000.00, 'Credit Card', 'Paid', 'Admin_Jane'),
    (9, '2023-09-20 08:30:00', 200.00, 'Cash', 'Paid', 'Admin_Joy'),
    (10, '2023-08-01 12:40:00', 7000.00, 'PromptPay', 'Paid', 'Admin_Jane');
GO

-- 9. ข้อมูลรายละเอียดใบเสร็จ (receipt_details)
INSERT INTO dbo.receipt_details 
    (receipt_id, item_name, quantity, unit_price, subtotal)
VALUES 
    (1, 'แพ็กเกจราย 1 ปี (Basic)', 1, 14000.00, 14000.00),
    (2, 'แพ็กเกจราย 1 ปี (VIP)', 1, 24000.00, 24000.00),
    (3, 'แพ็กเกจราย 1 เดือน (Basic)', 1, 1500.00, 1500.00),
    (4, 'แพ็กเกจราย 1 เดือน (VIP)', 1, 2500.00, 2500.00),
    (5, 'แพ็กเกจราย 3 เดือน (Basic)', 1, 4000.00, 4000.00),
    (6, 'แพ็กเกจนักศึกษา (รายเดือน)', 1, 1000.00, 1000.00),
    (7, 'แพ็กเกจราย 6 เดือน (Basic)', 1, 7500.00, 7500.00),
    (8, 'แพ็กเกจราย 6 เดือน (VIP)', 1, 13000.00, 13000.00),
    (9, 'แพ็กเกจรายวัน (Day Pass)', 1, 200.00, 200.00),
    (10, 'แพ็กเกจราย 3 เดือน (VIP)', 1, 7000.00, 7000.00);
GO

-- 10. แสดงข้อมูลทั้งหมดหลังเพิ่มเสร็จ
SELECT * FROM dbo.membership_types;
SELECT * FROM dbo.members;
SELECT * FROM dbo.instructors;
SELECT * FROM dbo.fitness_classes;
SELECT * FROM dbo.class_schedules;
SELECT * FROM dbo.class_bookings;
SELECT * FROM dbo.receipts;
SELECT * FROM dbo.receipt_details;
GO