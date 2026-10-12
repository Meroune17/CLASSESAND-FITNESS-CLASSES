   
 -- 1. CREATE DATABASE
IF DB_ID('FitnessDB') IS NULL
BEGIN
    CREATE DATABASE FitnessDB;
END
GO
USE FitnessDB;
GO

-- 2. CREATE TABLES

-- Membership Types (ประเภทแพ็กเกจ)
IF OBJECT_ID('dbo.membership_types', 'U') IS NULL
BEGIN
    CREATE TABLE membership_types (
        membership_type_id INT IDENTITY(1,1) PRIMARY KEY,
        type_name VARCHAR(100) NOT NULL,
        price DECIMAL(10,2) NOT NULL,
        duration_days INT NOT NULL
    );
END
GO

-- Members (สมาชิก)
IF OBJECT_ID('dbo.members', 'U') IS NULL
BEGIN
    CREATE TABLE members (
        member_id INT IDENTITY(1,1) PRIMARY KEY,
        first_name VARCHAR(100) NOT NULL,
        last_name VARCHAR(100) NOT NULL,
        email VARCHAR(100) UNIQUE NOT NULL,
        phone_number VARCHAR(20) NOT NULL,
        membership_type_id INT,
        join_date DATE NOT NULL,
        expire_date DATE NOT NULL,
        created_at DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (membership_type_id) REFERENCES membership_types(membership_type_id)
    );
END
GO

-- Instructors (เทรนเนอร์)
IF OBJECT_ID('dbo.instructors', 'U') IS NULL
BEGIN
    CREATE TABLE instructors (
        instructor_id INT IDENTITY(1,1) PRIMARY KEY,
        first_name VARCHAR(100) NOT NULL,
        last_name VARCHAR(100) NOT NULL,
        specialty VARCHAR(150)
    );
END
GO

-- Fitness Classes (คลาสเรียน)
IF OBJECT_ID('dbo.fitness_classes', 'U') IS NULL
BEGIN
    CREATE TABLE fitness_classes (
        class_id INT IDENTITY(1,1) PRIMARY KEY,
        class_name VARCHAR(100) NOT NULL,
        description TEXT
    );
END
GO

-- Class Schedules (รอบตารางสอน)
IF OBJECT_ID('dbo.class_schedules', 'U') IS NULL
BEGIN
    CREATE TABLE class_schedules (
        schedule_id INT IDENTITY(1,1) PRIMARY KEY,
        class_id INT NOT NULL,
        instructor_id INT NOT NULL,
        room_name VARCHAR(50),
        start_time DATETIME NOT NULL,
        end_time DATETIME NOT NULL,
        max_capacity INT NOT NULL,
        FOREIGN KEY (class_id) REFERENCES fitness_classes(class_id),
        FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id)
    );
END
GO

-- Class Bookings (การจองคลาส)
IF OBJECT_ID('dbo.class_bookings', 'U') IS NULL
BEGIN
    CREATE TABLE class_bookings (
        booking_id INT IDENTITY(1,1) PRIMARY KEY,
        member_id INT NOT NULL,
        schedule_id INT NOT NULL,
        booking_status VARCHAR(20) DEFAULT 'Confirmed'
            CHECK (booking_status IN ('Confirmed', 'Cancelled', 'Attended')),
        booking_date DATETIME DEFAULT GETDATE(),
        FOREIGN KEY (member_id) REFERENCES members(member_id),
        FOREIGN KEY (schedule_id) REFERENCES class_schedules(schedule_id)
    );
END
GO

-- Receipts (ใบเสร็จรับเงิน)
IF OBJECT_ID('dbo.receipts', 'U') IS NULL
BEGIN
    CREATE TABLE receipts (
        receipt_id INT IDENTITY(1,1) PRIMARY KEY,
        member_id INT NOT NULL,
        receipt_date DATETIME DEFAULT GETDATE(),
        total_amount DECIMAL(10,2) NOT NULL,
        payment_method VARCHAR(20) NOT NULL
            CHECK (payment_method IN ('Cash', 'Credit Card', 'Bank Transfer', 'PromptPay')),
        payment_status VARCHAR(20) DEFAULT 'Paid'
            CHECK (payment_status IN ('Paid', 'Pending', 'Cancelled', 'Refunded')),
        cashier_name VARCHAR(100),
        FOREIGN KEY (member_id) REFERENCES members(member_id)
    );
END
GO

-- Receipt Details (รายละเอียดใบเสร็จ)
IF OBJECT_ID('dbo.receipt_details', 'U') IS NULL
BEGIN
    CREATE TABLE receipt_details (
        detail_id INT IDENTITY(1,1) PRIMARY KEY,
        receipt_id INT NOT NULL,
        item_name VARCHAR(150) NOT NULL,
        quantity INT DEFAULT 1,
        unit_price DECIMAL(10,2) NOT NULL,
        subtotal DECIMAL(10,2) NOT NULL,
        FOREIGN KEY (receipt_id) REFERENCES receipts(receipt_id) ON DELETE CASCADE
    );
END
GO

-- 3. INSERT DATA
-- เพิ่มข้อมูลเฉพาะเมื่อยังไม่มีข้อมูลประเภทแพ็กเกจ
IF NOT EXISTS (SELECT 1 FROM dbo.membership_types)
BEGIN
    -- Membership Types
    INSERT INTO membership_types (type_name, price, duration_days)
    VALUES 
        ('ราย 1 เดือน (Basic)', 1500.00, 30),
        ('ราย 3 เดือน (Basic)', 4000.00, 90),
        ('ราย 1 ปี (VIP)', 24000.00, 365);

    -- Members
    INSERT INTO members (first_name, last_name, email, phone_number, membership_type_id, join_date, expire_date)
    VALUES 
        ('สมชาย', 'ใจดี', 'somchai@email.com', '0811111111', 1, '2023-10-01', '2023-10-31'),
        ('สมหญิง', 'รักดี', 'somying@email.com', '0822222222', 3, '2023-10-05', '2024-10-05');

    -- Instructors
    INSERT INTO instructors (first_name, last_name, specialty)
    VALUES 
        ('แจ็ค', 'นักกล้าม', 'Weight Training'),
        ('แอน', 'ยืดหยุ่น', 'Yoga');

    -- Fitness Classes
    INSERT INTO fitness_classes (class_name, description)
    VALUES 
        ('Yoga Beginner', 'คลาสโยคะสำหรับผู้เริ่มต้น'),
        ('HIIT Blast', 'คลาสออกกำลังกายหนักสลับเบา');

    -- Class Schedules
    INSERT INTO class_schedules (class_id, instructor_id, room_name, start_time, end_time, max_capacity)
    VALUES 
        (1, 2, 'Room A', '2026-10-15 10:00:00', '2026-10-15 11:00:00', 20),
        (2, 1, 'Room B', '2026-10-15 17:00:00', '2026-10-15 18:00:00', 15);

    -- Class Bookings
    INSERT INTO class_bookings (member_id, schedule_id, booking_status)
    VALUES 
        (1, 1, 'Confirmed'),
        (2, 2, 'Confirmed');

    -- Receipts
    INSERT INTO receipts (member_id, total_amount, payment_method, payment_status, cashier_name)
    VALUES 
        (1, 1500.00, 'PromptPay', 'Paid', 'Admin_Jane'),
        (2, 24000.00, 'Credit Card', 'Paid', 'Admin_Joy');

    -- Receipt Details
    INSERT INTO receipt_details (receipt_id, item_name, quantity, unit_price, subtotal)
    VALUES 
        (1, 'แพ็กเกจราย 1 เดือน (Basic)', 1, 1500.00, 1500.00),
        (2, 'แพ็กเกจราย 1 ปี (VIP)', 1, 24000.00, 24000.00);
END
GO
