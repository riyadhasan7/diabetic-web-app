CREATE DATABASE IF NOT EXISTS diabetes_db;
USE diabetes_db;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS user_records (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    age FLOAT,
    bmi FLOAT,
    HbA1c_level FLOAT,
    blood_glucose_level FLOAT,
    gender VARCHAR(10),
    smoking_history VARCHAR(20),
    heart_disease INT,
    hypertension INT,
    prediction VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

