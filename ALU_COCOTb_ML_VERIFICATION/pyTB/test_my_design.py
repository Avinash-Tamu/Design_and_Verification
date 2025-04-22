import cocotb
from cocotb.regression import TestFactory
from cocotb.triggers import RisingEdge, Timer
import random
import pickle
import numpy as np


#Generate clock pulses
async def generate_clock(dut):
    """Generate clock pulses."""
    while True:
        dut.clk.value = 0
        await Timer(1, units="ns")
        dut.clk.value = 1
        await Timer(1, units="ns")


# Load the trained model for predicting operation results
with open('../pyModel/operation_model_tree.pkl', 'rb') as f:
    model = pickle.load(f)


# Prediction function using the trained model
def predict_c(a, b, operation_type):
    """Use the ML model to predict the output c based on operation type."""
    # Ensure a and b are converted to integers (if necessary) and create the feature array
    input_array = np.array([[int(a), int(b), int(operation_type)]])
    return model.predict(input_array)[0]



values = [
    "OPERATION TYPE",
    "ADDITION = 0",
    "SUBTRACTION = 1",
    "MULTIPLICATION = 2",
    "DIVISION = 3",
    "AND = 4",
    "OR = 5",
    "XOR = 6",
    "NOT = 7",
    "SHIFT LEFT (LSL) = 8",
    "SHIFT RIGHT (LSR) = 9",
];
TOLERANCE = 1e-8

# Global coverage variables for functional coverage
coverage_map = {
    "add": False,
    "sub": False,
    "mul": False,
    "div": False,
    "and_op": False,
    "or_op": False,
    "xor_op": False,
    "not_op": False,
    "lsl": False,
    "lsr": False,
}

# Tied to the operation type for functional coverage tracking
operation_map = {
    0: "add",
    1: "sub",
    2: "mul",
    3: "div",
    4: "and_op",
    5: "or_op",
    6: "xor_op",
    7: "not_op",
    8: "lsl",
    9: "lsr",
}
print ()
for value in values:
    print(value.rjust(70))

print ()
@cocotb.test()
async def my_first_test(dut):
    """Test for ALU functionality."""

    # Start clock generation
    cocotb.start_soon(generate_clock(dut))
    await RisingEdge(dut.clk)

    # Apply random test stimulus
    dut.a.value = random.randint(0, 100)
    dut.b.value = random.randint(1, 100)
    
    # Randomly choose an operation type (0 = add, 1 = sub, 2 = mul)
    operation_type = random.choice([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]) 
    
    # Assign the operation type to the DUT
    dut.operation_type.value = operation_type
    # Track coverage for operation type
    op_name = operation_map[operation_type]
    coverage_map[op_name] = True
    
    await Timer(10, units="ns")

    await RisingEdge(dut.clk)
    

    # Use the model to predict the expected value of c
    predicted_c = round(predict_c(dut.a.value, dut.b.value, operation_type),8)
    


    dut_c_value = int(dut.c.value) 
    if dut_c_value >= 2**31:  # Check if the value is in the upper half of unsigned 32-bit
        dut_c_value -= 2**32


    dut._log.info("a = %d, b = %d, operation = %d, predicted c = %d, actual c = %d", dut.a.value, dut.b.value, operation_type, predicted_c, dut_c_value)

    # Assert that the predicted c matches the ALU output c
    assert abs(dut_c_value - predicted_c) < TOLERANCE, f"Expected c = {predicted_c}, but got {dut_c_value}"


@cocotb.test()
async def my_second_test(dut):
    """Test for ALU functionality with multiple test cases."""

    # Start clock generation in the background
    cocotb.start_soon(generate_clock(dut))

    for _ in range(50):  # Run 10 test cases
        await RisingEdge(dut.clk)
        dut.a.value = random.randint(0, 100)
        dut.b.value = random.randint(1, 100)
        
        operation_type = random.choice([0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
        
        dut.operation_type.value = operation_type

        # Track coverage for operation type
        op_name = operation_map[operation_type]
        coverage_map[op_name] = True
        
        #await Timer(1, units="ns")

        await RisingEdge(dut.clk)
        await RisingEdge(dut.clk)
        await RisingEdge(dut.clk)

        predicted_c = round(predict_c(dut.a.value, dut.b.value, operation_type),8)

        dut_c_value = int(dut.c.value) 
        if dut_c_value >= 2**31:  # Check if the value is in the upper half of unsigned 32-bit
            dut_c_value -= 2**32

        # Log the values for debugging
        dut._log.info("a = %0d, b = %0d, operation = %0d, predicted c = %0d, actual c = %0d", 
                      dut.a.value, dut.b.value, operation_type, predicted_c, dut_c_value)

        assert abs(dut_c_value - predicted_c) < TOLERANCE, f"Expected c = {predicted_c}, but got {dut_c_value}"


@cocotb.test()
async def coverage_report(dut):
    """Final test to print the coverage report for the ALU operations."""
    # Print out the coverage map showing which operations have been tested
    dut._log.info("Functional coverage summary:")
    for operation, covered in coverage_map.items():
        dut._log.info(f"{operation}: {'Covered' if covered else 'Not Covered'}")

