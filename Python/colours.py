colours = ["Red", "Yellow", "Green", "Blue"]

i = 0
while i < len(colours):
    print("When I was %d, my favourite colour was %s" % (i, colours[i]))
    i += 1

def main():
    print("Yes, \"__name__\" of file is equals to \"__main__\".")

if __name__ == '__main__':
    main()

import user_key