from colorama import Fore
import os
""""
Here The Comments are the same of the task 1 Comments but the new is i used os library for exiting the script as a another method

"""


def user_input():
    try:
        year_inputs = int(input(Fore.LIGHTCYAN_EX + "[+] Enter The Year : "))
        if year_inputs <= 0:
            print(Fore.LIGHTRED_EX +
                  "\n\tSorry! - You Put Negative Year Or You Put Year as 0 \n")
            check = int(input(Fore.LIGHTYELLOW_EX +
                              "[+] You Want To Add Year Again Press 1 Or Press 2 to Exit The Script : "))
            print(' ')
            if check == 1:
                user_input()
            else:
                os._exit(0)
        else:
            print(Fore.LIGHTGREEN_EX + f'\n\t[+] Your Year is : {year_inputs}')
            Results = is_leap(year_inputs)
            print(Fore.LIGHTMAGENTA_EX +
                  f"\n\t\tYour Result is : {Results}")
    except:
        print(Fore.LIGHTRED_EX + "\n\tSorry! - You Put An Empty or Wrong Year \n")
        check = int(input(Fore.LIGHTYELLOW_EX +
                          "[+] You Want To Add Year Again Press 1 Or Press 2 to Exit The Script : "))
        print(' ')
        if check == 1:
            user_input()
        else:
            os._exit(0)


def is_leap(year):
    if year % 4 == 0:
        if year % 100 != 0:
            return True
        else:
            if year % 400 == 0:
                return True
            else:
                return False
    else:
        return False


user_input()
print(Fore.LIGHTYELLOW_EX + "\n\t\tTask Successfully Completed :) ")
