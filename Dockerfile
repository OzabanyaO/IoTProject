# ใช้ Python slim image เป็นฐาน
FROM python:3.10-slim

# ติดตั้ง dependency ของระบบ เช่น Tesseract OCR พร้อมภาษาไทย
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    tesseract-ocr-tha \
    libsm6 \
    libxext6 \
    libxrender-dev \
    && rm -rf /var/lib/apt/lists/*

# ตั้ง working directory
WORKDIR /app

# คัดลอกไฟล์ requirements.txt และติดตั้ง Python dependencies
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# คัดลอกไฟล์ทั้งหมดไปที่ container
COPY . .

# กำหนดคำสั่งเริ่มต้น เมื่อ container รัน
CMD ["gunicorn", "server:app", "--bind", "0.0.0.0:$PORT"]
