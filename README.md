# Sky Garden Adventure — Lab 5 (First 3D Game)

เกม 3D Platformer สร้างด้วย **Godot 4.7** ต่อยอดจาก [3D Platformer Starter Kit](https://github.com/SilverDemons-PK/3D-Platformer-Kit)

- รหัส: 673380641-6
- ชื่อ-สกุล: นายศาสตรพล อนันเอื้อ
- กลุ่มเรียน: 2

**เล่นเกมออนไลน์:** https://sattraphona-pixel.github.io/GameLab5/

## วิธีเล่น
เก็บเหรียญให้ครบทุกเหรียญในด่าน แล้วเข้าประตูเพื่อไปด่านต่อไป หลบหนาม แท่งหมุน และอย่าตกเกาะ

| ปุ่ม | การทำงาน |
|---|---|
| W A S D | เดิน |
| Space | กระโดด (กดซ้ำกลางอากาศ = กระโดดสองชั้น/ตีลังกา) |
| Q / E หรือ ลูกศร | หมุนกล้อง |
| R | เริ่มด่านใหม่ |
| P / Esc | พัก |

## ด่าน
1. **Sunny Sky Garden** – เกาะลอยฟ้ายามกลางวัน (22 เหรียญ)
2. **Crystal Sunset** – เกาะคริสตัลยามพระอาทิตย์ตก (27 เหรียญ)

ในด่านมี: หนาม, แท่งหมุน, แท่นกระโดด (Jump Pad), แพลตฟอร์มเคลื่อนที่, แพลตฟอร์มที่ร่วงเมื่อเหยียบ, Checkpoint, ประตูที่เปิดเมื่อเก็บเหรียญครบ

## สิ่งที่แก้ไขจาก Starter Kit
- เปลี่ยนตัวละคร Player เป็นโมเดล Low-Poly ใหม่ และจัด Animation ให้ครบเหมือนชุดเดิม (Idle / Run / Jump / Flip)
- สร้าง 2 ด่านใหม่ พร้อมตกแต่ง (ต้นไม้ ดอกไม้ เมฆ คริสตัล สะพาน ธง) และ Menu / Win / HUD ใหม่
- เพิ่ม Coyote time, Jump buffer, ระบบ Checkpoint, เพลงและเสียงประกอบ

## Credits
- โค้ดต้นแบบ: SD Studios – 3D Platformer Starter Kit (CC0)
- โมเดล Low-Poly: Kenney (kenney.nl) – Starter Kit 3D Platformer (CC0)
- เสียงเพลง/เอฟเฟกต์: สังเคราะห์เอง + เสียงจาก kit (CC0)
