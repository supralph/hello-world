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


number3 = input("Enter 3rd number:")
number4 = input("Enter 4th number:")

while True:
    if number3.isdigit() and number4.isdigit():
        y = int(number3) * int(number4)
        print("3rd number + 4th number =", y)
    else:
        print("Please input a number.")
    break



from util.postgres import PSQL

pg = PSQL("username", "pass", "host")
df = pg.get_result("SELECT * FROM xxx")
pg.create_table_from_query("SELECT * FROM XXX LIMIT 100", dataset="warehouse", table_name="inventory")

abc test NEW


Publisher Subscriber

ticket change state >> publish message to a topic >>
read message from topic >> stream to table


google tag manager >> webhook http post request with json payload

