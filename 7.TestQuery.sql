-- ========================================================
-- คำสั่งเรียกดูข้อมูลทั้งหมด (Select Data)
-- ========================================================

-- 1. ดูข้อมูลประเภทแพ็กเกจสมาชิกทั้งหมด
SELECT * FROM Membership_Types;

-- 2. ดูข้อมูลสมาชิกทั้งหมด
SELECT * FROM Members;

-- 3. ดูข้อมูลเทรนเนอร์ทั้งหมด
SELECT * FROM Instructors;

-- 4. ดูข้อมูลคลาสเรียนทั้งหมด
SELECT * FROM Fitness_Classes;

-- 5. ดูข้อมูลรอบตารางคลาสทั้งหมด
SELECT * FROM Class_Schedules;

-- 6. ดูประวัติการจองคลาสทั้งหมด
SELECT * FROM Class_Bookings;

-- 7. ดูข้อมูลใบเสร็จรับเงินหลักทั้งหมด
SELECT * FROM Receipts;

-- 8. ดูรายละเอียดรายการในใบเสร็จทั้งหมด
SELECT * FROM Receipt_Details;

--- เทสที่ 1: ตรวจสอบรายชื่อสมาชิกว่าแต่ละคนใช้แพ็กเกจอะไร และหมดอายุเมื่อไหร่
SELECT 
    m.member_id, 
    m.first_name + ' ' + m.last_name AS 'ชื่อ-นามสกุล', 
    m.phone_number AS 'เบอร์โทรศัพท์',
    mt.type_name AS 'ชื่อแพ็กเกจ', 
    m.expire_date AS 'วันหมดอายุ'
FROM Members m
JOIN Membership_Types mt ON m.membership_type_id = mt.membership_type_id
ORDER BY m.member_id;

---เทสที่ 2: ดูตารางสอนว่า คลาสไหน ใครเป็นคนสอน และเรียนที่ห้องไหน เวลาอะไร

SELECT 
    fc.class_name AS 'วิชาเรียน', 
    i.first_name + ' ' + i.last_name AS 'ชื่อเทรนเนอร์', 
    cs.room_name AS 'ห้องเรียน', 
    cs.start_time AS 'เวลาเริ่มคลาส', 
    cs.end_time AS 'เวลาจบคลาส',
    cs.max_capacity AS 'รับได้สูงสุด (คน)'
FROM Class_Schedules cs
JOIN Fitness_Classes fc ON cs.class_id = fc.class_id
JOIN Instructors i ON cs.instructor_id = i.instructor_id
ORDER BY cs.start_time;

---เทสที่ 3: ดูประวัติการจองคลาส ว่าสมาชิกคนไหน จองคลาสอะไรไปบ้าง สถานะเป็นอย่างไร

SELECT 
    m.first_name AS 'ชื่อสมาชิก', 
    fc.class_name AS 'คลาสที่จอง', 
    i.first_name AS 'เทรนเนอร์',
    cs.start_time AS 'เวลาเรียน',
    cb.booking_status AS 'สถานะการจอง',
    cb.booking_date AS 'วันเวลาที่กดจอง'
FROM Class_Bookings cb
JOIN Members m ON cb.member_id = m.member_id
JOIN Class_Schedules cs ON cb.schedule_id = cs.schedule_id
JOIN Fitness_Classes fc ON cs.class_id = fc.class_id
JOIN Instructors i ON cs.instructor_id = i.instructor_id
ORDER BY cb.booking_date DESC;

---เทสที่ 4: ดูรายละเอียดใบเสร็จรับเงิน ว่าใครจ่ายเงินค่าอะไรบ้าง จ่ายผ่านช่องทางไหน

SELECT 
    r.receipt_id AS 'เลขที่ใบเสร็จ',
    m.first_name + ' ' + m.last_name AS 'ชื่อลูกค้า',
    rd.item_name AS 'รายการสินค้า/บริการ',
    rd.subtotal AS 'ราคา',
    r.payment_method AS 'ช่องทางชำระเงิน',
    r.receipt_date AS 'วันที่ออกบิล'
FROM Receipts r
JOIN Receipt_Details rd ON r.receipt_id = rd.receipt_id
JOIN Members m ON r.member_id = m.member_id
ORDER BY r.receipt_id;

---เทสที่ 5: สรุปยอดรายได้ (หาผลรวม) แยกตามช่องทางการชำระเงิน

SELECT 
    payment_method AS 'ช่องทางการชำระเงิน', 
    SUM(total_amount) AS 'ยอดรายได้รวม (บาท)',
    COUNT(receipt_id) AS 'จำนวนบิล'
FROM Receipts
GROUP BY payment_method
ORDER BY SUM(total_amount) DESC;