# 🩺 Am I Diabetic? – Diabetes Prediction Web App                                                                                  

**Am I Diabetic?** is a machine learning-powered web application that allows users to predict their likelihood of having diabetes based on key health indicators. The app provides real-time predictions using a trained ML model and offers personalized feedback to help users understand and manage their health better.

## 🚀 Project Overview

This project aims to leverage machine learning to assist individuals in detecting early signs of diabetes. By collecting user input through a secure web form, the application evaluates the data using a trained classifier and provides immediate predictions.

Users must create an account to access the prediction system, which ensures data privacy and enables the app to track their health progress over time through visual insights and charts.

---

## 🔍 Features

- 🧠 Trained ML model using health features like BMI, glucose levels, and HbA1c
- 🔐 User authentication and login system
- 📊 Interactive dashboard with personalized feedback and progress charts
- 💾 Prediction history stored in a secure MySQL database
- 📎 CSV export and downloadable prediction reports
- 🔄 Real-time diabetes prediction
- 🌐 Web app built using Flask (backend) and React.js (frontend)

---

## 🧠 Machine Learning Model

### ➤ Input Features:
- `HbA1c_level`
- `blood_glucose_level`
- `age`
- `bmi`
- `hypertension` (0 or 1)
- `heart_disease` (0 or 1)
- `smoking_history` (categorical)
- `gender` (categorical)

### ➤ Algorithms Used:
- Logistic Regression
- Random Forest
- Gradient Boosting (Final chosen model)
- Decision Tree

The final model (Gradient Boosting) was selected based on performance metrics (accuracy, precision, recall, F1-score) and ability to handle complex feature interactions.
          
---

##   Tech Stack

| Layer       | Tools/Technologies                      |
|-------------|-----------------------------------------|
| Frontend    | React.js, HTML, CSS                     |
| Backend     | Flask (Python)                          |
| ML Modeling | Scikit-learn, Pandas, NumPy             |
| Database    | MySQL                                   |

---

## 🔒 Security and Privacy

- All user credentials are encrypted
- Secure database storage with access control
- Data encryption protocols in place
- No personally identifiable health data is exposed
- Compliance-ready structure for future production deployment

---

## 📦 Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/riyadhasan7/am-i-diabetic.git
   cd am-i-diabetic

 2. **Run the app**
    ```bash
    docker compose up --build -d
    
 3. **View the web app**
    ```bash
    <public-ip-address>:80
