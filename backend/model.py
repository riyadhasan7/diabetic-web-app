import pandas as pd
import matplotlib.pyplot as plt
import joblib


# Ensure the correct file path
df = pd.read_csv("diabetes_prediction_dataset.csv")


# Separate numerical and categorical columns
numerical_cols = df.select_dtypes(include=['number']).columns
categorical_cols = df.select_dtypes(include=['category']).columns

print("Numerical columns:", numerical_cols)
print("Categorical columns:", categorical_cols)

# Check for duplicates
duplicates = df[df.duplicated()]
print("Number of duplicate rows:", len(duplicates))

# Remove duplicates (inplace modification)
df.drop_duplicates(inplace=True)

# Verify the removal
print("Number of rows after removing duplicates:", len(df))


# Replace 'No' and 'Yes' in heart_disease and hypertension columns back to 0 and 1
df['heart_disease'] = df['heart_disease'].replace({'No': 0, 'Yes': 1})
df['hypertension'] = df['hypertension'].replace({'No': 0, 'Yes': 1})
df['diabetes'] = df['diabetes'].replace({'No': 0, 'Yes': 1})

# Convert binary columns to int
df['heart_disease'] = df['heart_disease'].astype(int)
df['hypertension'] = df['hypertension'].astype(int)
df['age'] = df['age'].astype('int')

# Create the pie chart
plt.figure(figsize=(8, 8))
df['diabetes'].value_counts().plot.pie(autopct='%1.1f%%', startangle=90)
plt.title('Distribution of Diabetes')
plt.ylabel('')
plt.show()





from imblearn.over_sampling import RandomOverSampler
from sklearn.model_selection import train_test_split
import pandas as pd
import matplotlib.pyplot as plt

# Separate features and target
X = df.drop('diabetes', axis=1)
y = df['diabetes']

# Encode categorical variables
X = pd.get_dummies(X, columns=['gender', 'smoking_history'])

# Split before applying Random Oversampling
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

# Apply Random Oversampling to training data only
ros = RandomOverSampler(random_state=42)  # Use RandomOverSampler
X_train_resampled, y_train_resampled = ros.fit_resample(X_train, y_train)

# Create a new DataFrame with the resampled data
df_resampled = pd.DataFrame(X_train_resampled, columns=X_train.columns)
df_resampled['diabetes'] = y_train_resampled

# Visualize the balanced target variable using a pie chart
plt.figure(figsize=(8, 8))
df_resampled['diabetes'].value_counts().plot.pie(autopct='%1.1f%%', startangle=90)
plt.title('Distribution of Diabetes (After Random Oversampling)')
plt.ylabel('')
plt.show()


df_resampled.info()

from sklearn.ensemble import GradientBoostingClassifier
from sklearn.model_selection import train_test_split, cross_val_score, GridSearchCV
from sklearn.metrics import classification_report, accuracy_score, confusion_matrix, ConfusionMatrixDisplay


# Step 4: Initialize the Gradient Boosting Classifier
gb_classifier = GradientBoostingClassifier(random_state=42)

# Step 5: Define the hyperparameters grid for GridSearchCV
param_grid = {
    'n_estimators': [100, 150],
    'learning_rate': [0.1],
    'max_depth': [3, 5],
    'subsample': [0.8, 1.0]
}

# Step 6: Perform GridSearchCV
grid_search = GridSearchCV(estimator=gb_classifier,
                           param_grid=param_grid,
                           cv=3, n_jobs=-1,
                           verbose=1,
                           scoring='accuracy')

# Train the model
grid_search.fit(X_train_resampled, y_train_resampled)

# Step 7: Output best parameters from GridSearchCV
print("Best Parameters from GridSearchCV:", grid_search.best_params_)

# Step 8: Get the best model and make predictions
best_gb_classifier = grid_search.best_estimator_
y_pred = best_gb_classifier.predict(X_test)

# Make a pickle file for our model
joblib.dump(best_gb_classifier, open("model.pkl", "wb"))

# Cross-validation on full resampled dataset using best model
cv_scores = cross_val_score(best_gb_classifier, X_train_resampled, y_train_resampled, cv=3)
print("Cross-validation scores:", cv_scores)
print("Mean CV Accuracy:", cv_scores.mean())

# Step 9: Evaluate the model
print("\nAccuracy on Test Set:", accuracy_score(y_test, y_pred))
print("\nClassification Report:\n", classification_report(y_test, y_pred))

# Step 10: Confusion Matrix (optional)
cm = confusion_matrix(y_test, y_pred)
disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=["No Diabetes", "Diabetes"])
disp.plot(cmap=plt.cm.Greens)
plt.title("Confusion Matrix - Gradient Boosting")
plt.show()

# Load the trained model
model = joblib.load('model.pkl')

# Use the model for prediction
prediction = model.predict(X_test)