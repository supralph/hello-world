# Lab 1

### Question 1
def q1():
    print('Q1.')

    f = int(input('Farenheit = '))
    c = (5/9)*(f - 32)
    print('Celcius = ', c)

    print('\n')
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

    print('\n')
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

    print('\n')
q3()

### Question 4
def q4():
    print('Q4.')

    x4 = int(input('Positive Integer: '))

    hour = x4 // 3600
    min = (x4 - (hour * 3600)) // 60
    sec = (x4 - (hour * 3600) - (min * 60))

    print('Hour: ', hour, '/ Minute: ', min, '/ Second: ', sec)

    print('\n')
q4()

### Question 5
def q5():
    print('Q5.')


    print('\n')
q5()