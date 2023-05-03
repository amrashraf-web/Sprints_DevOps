from colorama import Fore

"""
1 - Here i used a lot of functions to be more organized and make the code easy for reading and understanding
2 - I used Colorama Library to use color for each Input,Output and Errors to make differance between them
3 - I used if conditions for checking each input and used try exception for checking also but with different way
4 - I used tab space for the outputs to be more different than inputs 

"""


def first():
    # i used global to pass the user_input for the task function
    global user_input
    user_input = input(Fore.LIGHTCYAN_EX + "\n[+] Enter Your String : ")
    # i want to check the input if empty or not string because the input must be string
    # also i used function isnumeric to check the input if interger or not because i need to use string only
    if user_input == "" or user_input.isnumeric():
        print(Fore.LIGHTRED_EX + "\n\tSorry! - You Put An Empty or Wrong String\n")
        # here i ask the user to tell him if he want to continue to add the string again or exit the script
        check = int(input(Fore.LIGHTYELLOW_EX +
                          "[+] You Want To Add String Again Press 1 Or Press 2 to Exit The Script : "))
        print(' ')
        if check == 1:
            # here if the user want to continue it will return again to the same function untill he put the right string
            first()
        else:
            # here mean the user don't want to continue the script so i closed the script
            exit()
    else:
        # if the code continued till the line mean the function run successfully without any error and go to the next function
        print(Fore.LIGHTGREEN_EX + f'\n\t[+] Your String is : {user_input}')


def second():
    # i used global to pass the user_index for the task function
    global user_index
    # i used another checking for check the input instead of using if condition only
    try:
        # here i used int() function because i need integer number only not string or anything
        user_index = int(
            input(Fore.LIGHTCYAN_EX + "\n[+] Enter Your Index Number : "))
        print(Fore.LIGHTGREEN_EX +
              f'\n\t[+] Your Index Number is : {user_index}')
    except:
        # if the user put string or anything except nubmer this mean he put wrong input so i asked him to fix it or close the script
        print(Fore.LIGHTRED_EX +
              "\n\tSorry! - You Put An Empty or Wrong Index Number \n")
        check = int(input(Fore.LIGHTYELLOW_EX +
                          "[+] You Want To Add Index Number Again Press 1 Or Press 2 to Exit The Script : "))
        print(' ')
        if check == 1:
            second()
        else:
            exit()


def third():
    # i used global to pass the user_word for the task function
    global user_word
    user_word = input(Fore.LIGHTCYAN_EX + "\n[+] Enter Your Word : ")
    if user_word == "" or user_input.isnumeric():
        print(Fore.LIGHTRED_EX + "\n\tSorry! - You Put An Empty or Wrong Word\n")
        check = int(input(Fore.LIGHTYELLOW_EX +
                          "[+] You Want To Add Word Again Press 1 Or Press 2 to Exit The Script : "))
        print(' ')
        if check == 1:
            third()
        else:
            exit()
    else:
        print(Fore.LIGHTGREEN_EX + f'\n\t[+] Your Word is : {user_word}')


def Task():
    # here i got the inputs which the user put them to solve the task
    get_string = list(user_input)
    get_index = user_index
    get_word = user_word
    get_string[get_index] = get_word
    Result = ''.join(get_string)
    print(Fore.LIGHTMAGENTA_EX +
          f"\n\t\tYour Result is : {Result}")
    # here the main output of the task so i used two tab spaces to make differance between inputs and output of inputs and the mai output of the task


def Start():
    # here i tell the script run each function in order and will not go to other function untill finishing the currently working function
    first()
    second()
    third()
    Task()
    # here mean all function completed successfully and task finished
    print(Fore.LIGHTYELLOW_EX + "\n\t\tTask Successfully Completed :) ")


# here i call the start function to run the script because without calling it , the script will not running
Start()
