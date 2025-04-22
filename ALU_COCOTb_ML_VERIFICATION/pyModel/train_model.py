import numpy as np
from sklearn.tree import DecisionTreeRegressor
import pickle

def train_and_save_model():
    """Train and save a decision tree model for different operations (addition, subtraction, multiplication)."""
    
    # Generate training data
    X = []  # Input features [a, b, operation_type]
    y = []  # Output result c
    
    # Generate data for addition, subtraction, and multiplication
    for a in range(150):
        for b in range(1,150):
            # Addition (operation_type = 0)
            X.append([a, b, 0])
            y.append(a + b)
            
            # Subtraction (operation_type = 1)
            X.append([a, b, 1])
            y.append(a - b)
            
            # Multiplication (operation_type = 2)
            X.append([a, b, 2])
            y.append(a * b)

            # Division (operation_type = 3)
            X.append([a, b, 3])
            y.append(a // b)

            # AND Operation (operation_type = 4)
            X.append([a, b, 4])
            y.append(a & b)

            # OR Operation (operation_type = 5)
            X.append([a, b, 5])
            y.append(a | b)

            # XOR Operation (operation_type = 6)
            X.append([a, b, 6])
            y.append(a ^ b)

            # NOT Operation (operation_type = 7) - Inverts only 'a'
            X.append([a, b, 7])
            y.append(~a)

            # Logical Shift Left (LSL) (operation_type = 8)
            X.append([a, b, 8])
            if b>31:
                y.append(0)
            else:
                y.append(a << b)

            # Logical Shift Right (LSR) (operation_type = 9)
            X.append([a, b, 9])
            if b>31:
                y.append(0)
            else:
                y.append(a >> b)

    
    X = np.array(X)
    y = np.array(y)

    # Train a decision tree regressor model
    model = DecisionTreeRegressor()
    model.fit(X, y)

    # Save the trained model to a file
    with open('../pyModel/operation_model_tree.pkl', 'wb') as f:
        pickle.dump(model, f)

# Run the training function
train_and_save_model()
