# Simple Math

number1 = input("Enter 1st number:")
number2 = input("Enter 2nd number:")

while True:
    if number1.isdigit() and number2.isdigit():
        x = int(number1) + int(number2)
        print("1st number + 2nd number =", x)
    else:
        print("Please input a number.")
    break