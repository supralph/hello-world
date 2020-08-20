# Lab 1

### Question 1
def q1():
    print('Q1.')

    f = int(input('Farenheit = '))
    c = (5/9)*(f - 32)
    print('Celcius = ', c)

    print()
q1()

### Question 2
def q2():
    print('Q2.')

    x2 = int(input('1st Number: '))
    y2 = int(input('2nd Number: '))
    z2 = int(input('3rd Number: '))

    sum2 = x2 + y2 + z2
    avg2 = (x2 + y2 + z2) / 3

    print('Sum = ', sum2)
    print('Average = ', avg2)

    print()
q2()

### Question 3
import math
def q3():
    print('Q3.')

    x3 = input('3 Digit Integer: ')
    y3 = [int(i) for i in x3]

    sum3 = sum(y3)
    prod3 = math.prod(y3)

    print('Sum = ', sum3)
    print('Product = ', prod3)

    print()
q3()

### Question 4
def q4():
    print('Q4.')

    x4 = int(input('Number of Seconds: '))

    hour = x4 // 3600
    min = (x4 - (hour * 3600)) // 60
    sec = (x4 - (hour * 3600) - (min * 60))

    print('Hour: ', hour, '/ Minute: ', min, '/ Second: ', sec)

    print()
q4()

### Question 5
def q5():
    print('Q5.')

    x5 = int(input('Enter Change: '))

    c50 = x5 // 50
    c10 = (x5 - (c50 * 50)) // 10
    c5 = (x5 - (c50 * 50) - (c10 * 10)) // 5
    c1 = (x5 - (c50 * 50) - (c10 * 10) - (c5 * 5))

    print('50 Cents: ', c50)
    print('10 Cents:', c10)
    print('5 Cents: ', c5)
    print('1 cents', c1)

    print()
q5()

### Question 6
def q6():
    print('Q6.')

    x6 = int(input('Enter Meal Amount: '))

    off50 = x6 * 0.50
    service_charge = off50 * 0.10
    gst = (off50 + service_charge) * 0.07
    total = off50 + service_charge + gst

    print('Receipt')
    print('Cost of Meal: ', x6)
    print('50% discount: ', off50)
    print('Service Charge: ', service_charge)
    print('GST: ', gst)
    print('Total Amount: ', total)

    print()
q6()

### Question 7
import math
def q7():
    print('Q7. ')

    x7 = int(input('Enter Length of 1st Side of Triangle: '))
    y7 = int(input('Enter Length of 2nd Side of Triangle: '))
    z7 = int(input('Enter Length of 3rd Side of Triangle: '))

    small_s = (1 / 2) * (x7 + y7 + z7)
    big_s = math.sqrt((small_s) * ((small_s - x7) * (small_s - y7) * (small_s - z7)))

    print('The Area of Triangle is: ', big_s)

    print()
q7()

### Question 8
def q8():
    print('Q8. ')


    print()
q8()