FROM python:3.10-slim

# ติดตั้ง dependencies ที่จำเป็นสำหรับ Tesseract OCR, OpenCV และไลบรารีที่เกี่ยวข้อง
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    tesseract-ocr-tha \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgl1-mesa-glx \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# คัดลอกและติดตั้ง Python dependencies
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# คัดลอกไฟล์ทั้งหมดไปยัง container
COPY . .

# รัน Gunicorn โดยใช้ shell เพื่อให้มีการ substitute environment variable $PORT
CMD ["sh", "-c", "gunicorn server:app --bind 0.0.0.0:$PORT"]
