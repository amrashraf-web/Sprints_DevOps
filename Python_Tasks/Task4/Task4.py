from datetime import datetime
from email_validator import validate_email
import phonenumbers
from phonenumbers import carrier
from phonenumbers.phonenumberutil import number_type
import csv
import glob
import pandas
import shutil
import os
from colorama import Fore, init
import sys
from termcolor import colored
from time import sleep

init(strip=not sys.stdout.isatty())
init()


class Capstone:
    def check_email(self):
        global Email
        Email = input(Fore.LIGHTWHITE_EX + "[+] Enter Your Email : ")
        try:
            validate_email(Email)
        except:
            print(" ")
            print(Fore.LIGHTRED_EX + "Sorry, You Put Invalid Email! .")
            print(" ")
            self.check_email()

    def check_phone(self):
        global Phone
        try:
            # Example : +201116182444
            Phone = input(Fore.LIGHTWHITE_EX + "[+] Enter Your Phone Number : ")
            carrier._is_mobile(number_type(phonenumbers.parse(Phone)))
        except:
            print(" ")
            print(Fore.LIGHTRED_EX + "Sorry, You Put Invalid Phone Number")
            print(" ")
            self.check_phone()

    def Create(self):
        Today = datetime.now().strftime("%d-%m-%Y")
        TimeNow = datetime.now().strftime("%d-%m-%Y %H:%M:%S")
        Name = input(Fore.LIGHTWHITE_EX + "[+] Enter Your Name : ")
        self.check_email()
        Address = input(Fore.LIGHTWHITE_EX + "[+] Enter Your Address : ")
        self.check_phone()

        Filename = f"ContactBook_{Today}.csv"
        Fields_Header = ["Name", "Email", "Address", "Phone Number", "Insertion Time"]
        Fields_Row = [
            {
                "Name": Name,
                "Email": Email,
                "Address": Address,
                "Phone Number": Phone,
                "Insertion Time": TimeNow,
            }
        ]

        if os.path.exists(Filename):
            with open(Filename, "a") as csvfile:
                write_csv = csv.DictWriter(csvfile, fieldnames=Fields_Header)
                write_csv.writerows(Fields_Row)
        else:
            with open(Filename, "w") as csvfile:
                write_csv = csv.DictWriter(csvfile, fieldnames=Fields_Header)
                write_csv.writeheader()
                write_csv.writerows(Fields_Row)
        print(" ")
        print(Fore.LIGHTGREEN_EX + "\t[+] Done Created ContactBook SuccessFully :)")
        return_menu()

    def View(self):
        path_csv = glob.glob("*.csv")
        length = len(path_csv)
        if length > 0:
            print(Fore.LIGHTYELLOW_EX + f"[+] You Have {length} Csv File ")
            print(" ")
            for i, name in enumerate(path_csv):
                print(Fore.LIGHTGREEN_EX + f"\t{i+1} - {name}")
            print(" ")

            def check_input():
                try:
                    check = int(
                        input(
                            Fore.LIGHTWHITE_EX
                            + "[+] Which Csv File You Want To View It : "
                        )
                    )
                    FileName = path_csv[check - 1]
                    csvFile = pandas.read_csv(FileName)
                    print(csvFile)
                    return_menu()
                except:
                    print(Fore.LIGHTRED_EX + "[+] Sorry, You Put Wrong Number")
                    check_input()

            check_input()

        else:
            input(Fore.LIGHTRED_EX + f"[+] Sorry, You Don't Have Csv Files ")
            print(" ")

    def Update(self):
        path_csv = glob.glob("*.csv")
        length = len(path_csv)
        if length > 0:
            print(Fore.LIGHTYELLOW_EX + f"[+] You Have {length} Csv File ")
            print(" ")
            for i, name in enumerate(path_csv):
                print(Fore.LIGHTGREEN_EX + f"\t{i+1} - {name}")
            print(" ")

            def select_num():
                global check_num, FileName
                try:
                    check_num = int(
                        input(
                            Fore.LIGHTWHITE_EX
                            + "[+] Which Csv File You Want To Update It : "
                        )
                    )
                    print(" ")
                    FileName = path_csv[check_num - 1]
                except:
                    print(Fore.LIGHTRED_EX + "[+] Sorry, You Selected Wrong Number :(")
                    print(" ")
                    select_num()

            select_num()
            csvFile = pandas.read_csv(FileName)
            store_length = len(csvFile)

            def select_line():
                global Number_Line
                try:
                    Number_Line = int(
                        input(
                            Fore.LIGHTWHITE_EX
                            + "[+] Which Line Number You Want To Update It : "
                        )
                    )
                    print(" ")
                    if Number_Line <= store_length:
                        pass
                except:
                    print(Fore.LIGHTRED_EX + "Sorry, You Put Wrong Number Line :(")
                    print(" ")
                    select_line()

            print(csvFile)
            print(" ")
            select_line()
            print(
                Fore.LIGHTMAGENTA_EX
                + "[1] Name\t\t[2] Email\n[3] Address\t\t[4] Phone Number"
            )
            print("")

            def select_field():
                global check_field, field_name, new_name
                try:
                    check_field = int(
                        input(
                            Fore.LIGHTWHITE_EX
                            + "[+] Which Field You Want To Update It : "
                        )
                    )
                    print(" ")
                    if check_field <= 4:
                        if check_field == 1:
                            field_name = "Name"
                            new_name = input(
                                Fore.LIGHTWHITE_EX + "[+] Enter Your Name : "
                            )
                        elif check_field == 2:
                            field_name = "Email"
                            self.check_email()
                            new_name = Email
                        elif check_field == 3:
                            field_name = "Address"
                            new_name = input(
                                Fore.LIGHTWHITE_EX + "[+] Enter Your Address : "
                            )
                        elif check_field == 4:
                            field_name = "Phone Number"
                            self.check_phone()
                            new_name = Phone
                    else:
                        print(Fore.LIGHTRED_EX + "Sorry, You Put Wrong Field Number :(")
                        print(" ")
                        select_field()
                except:
                    print(Fore.LIGHTRED_EX + "Sorry, You Put Wrong Field Number :(")
                    print(" ")
                    select_field()

            select_field()
            csvFile.loc[Number_Line - 1, field_name] = new_name
            csvFile.to_csv(FileName, index=False)
            print(" ")
            print(Fore.LIGHTGREEN_EX + "\tDone Updated Your Contact SuccessFully")
            print(" ")
            print(csvFile)
            return_menu()

        else:
            input(Fore.LIGHTRED_EX + f"[+] Sorry, You Don't Have Csv Files ")
            print(" ")

    def Remove(self):
        path_csv = glob.glob("*.csv")
        length = len(path_csv)
        if length > 0:
            print(Fore.LIGHTYELLOW_EX + f"[+] You Have {length} Csv File ")
            print(" ")
            for i, name in enumerate(path_csv):
                print(Fore.LIGHTGREEN_EX + f"\t{i+1} - {name}")
            print(" ")

            def select_csv():
                global check_num, FileName
                try:
                    check_num = int(
                        input(
                            Fore.LIGHTWHITE_EX
                            + "[+] Which Csv File You Want To Remove Contact From It : "
                        )
                    )
                    print(" ")
                    FileName = path_csv[check_num - 1]
                except:
                    print(Fore.LIGHTRED_EX + "[+] Sorry, You Selected Wrong Number :(")
                    print(" ")
                    select_csv()

            select_csv()
            csvFile = pandas.read_csv(FileName)
            store_length = len(csvFile)

            def select_line():
                global Number_Line
                try:
                    Number_Line = int(
                        input(
                            Fore.LIGHTWHITE_EX
                            + "[+] Which Line Number Line Of Contact You Want To Remove it It : "
                        )
                    )
                    print(" ")
                    if Number_Line <= store_length:
                        pass
                except:
                    print(Fore.LIGHTRED_EX + "Sorry, You Put Wrong Number Line :(")
                    print(" ")
                    select_line()

            print(csvFile)
            select_line()
            csvFile = csvFile.drop(Number_Line - 1)
            csvFile.to_csv(FileName)
            print(" ")
            print(Fore.LIGHTGREEN_EX + "\tDone Removed Your Contact SuccessFully")
            print(" ")
            print(csvFile)
            return_menu()
        else:
            input(Fore.LIGHTRED_EX + f"[+] Sorry, You Don't Have Csv Files ")
            print(" ")

    def Backup(self):
        path_csv = glob.glob("*.csv")
        length = len(path_csv)
        if length > 0:
            print(Fore.LIGHTYELLOW_EX + f"[+] You Have {length} Csv File ")
            print(" ")
            for i, name in enumerate(path_csv):
                print(Fore.LIGHTGREEN_EX + f"\t{i+1} - {name}")
            print(" ")

            def select_csv():
                global check_num, FileName
                try:
                    check_num = int(
                        input(
                            Fore.LIGHTWHITE_EX
                            + "[+] Which Csv File You Want To Backup It : "
                        )
                    )
                    print(" ")
                    FileName = path_csv[check_num - 1]
                except:
                    print(Fore.LIGHTRED_EX + "[+] Sorry, You Selected Wrong Number :(")
                    print(" ")
                    select_csv()

            select_csv()
            dst_dir = input(Fore.LIGHTWHITE_EX + "[+] Enter Your Backup Folder : ")
            print(" ")
            if not os.path.exists(dst_dir):
                os.makedirs(dst_dir)
            shutil.copy2(FileName, dst_dir)
            print(
                Fore.LIGHTGREEN_EX
                + f"\t[+] Done Backup File {FileName} SucessFully To This Folder >> {dst_dir}"
            )
            print(" ")
            return_menu()
        else:
            input(Fore.LIGHTRED_EX + f"[+] Sorry, You Don't Have Csv Files ")
            print(" ")


def return_menu():
    try:
        rtn_mnu = int(
            input(
                Fore.LIGHTCYAN_EX
                + "[+] You Want To Retun To Main Menu Press [ 1 ] or Exit Press [ 2 ] : "
            )
        )
        if rtn_mnu == 1:
            Start()
        else:
            print(" ")
            print(Fore.LIGHTBLUE_EX + "\tThank You for Using Contact Book :)")
            sleep(5)
            print(" ")
    except:
        print(" ")
        print(Fore.LIGHTRED_EX + "\tYou Put Wrong Number :()")
        sleep(5)
        print(" ")


def banner():
    os.system("cls")
    print(
        colored(
            """
              ____            _             _     ____              _    
             / ___|___  _ __ | |_ __ _  ___| |_  | __ )  ___   ___ | | __
            | |   / _ \| '_ \| __/ _` |/ __| __| |  _ \ / _ \ / _ \| |/ /
            | |__| (_) | | | | || (_| | (__| |_  | |_) | (_) | (_) |   < 
             \____\___/|_| |_|\__\__,_|\___|\__| |____/ \___/ \___/|_|\_\\
    """,
            "cyan",
        )
    )


def Start():
    banner()
    print(
        Fore.LIGHTGREEN_EX
        + """[*] Welcome To Contact Book :)\n
        \t[1] Add New Contact        [2] View All Contacts\n
        \t[3] Update A Contact       [4] Remove A Contact\n
        \t[5] Backup Your Conctact   [6] Exit\n"""
    )
    try:
        tool = int(input(Fore.LIGHTWHITE_EX + "[*] Enter Your Number >> "))
        if tool == 1:
            banner()
            Capstone().Create()
        elif tool == 2:
            banner()
            Capstone().View()
        elif tool == 3:
            banner()
            Capstone().Update()
        elif tool == 4:
            banner()
            Capstone().Remove()
        elif tool == 5:
            banner()
            Capstone().Backup()
        elif tool == 6:
            print(" ")
            print(Fore.LIGHTBLUE_EX + "\tThank You for Using Contact Book :)")
            sleep(5)
            print(" ")
        else:
            print(" ")
            print(
                Fore.LIGHTRED_EX
                + "[+] You Put Wrong Number :( - Please Wait 3 Seconds To Return Again"
            )
            print(" ")
            sleep(3)
            Start()
    except Exception as e:
        print(e)
        print(" ")
        print(
            Fore.LIGHTRED_EX
            + "[+] You Put Wrong Number :( - Please Wait 3 Seconds To Return Again"
        )
        print(" ")
        sleep(3)
        Start()


def return_menu():
    try:
        print(" ")
        rtn_mnu = int(
            input(
                Fore.LIGHTCYAN_EX
                + "[+] You Want To Retun To Main Menu Press [ 1 ] or Exit Press [ 2 ] : "
            )
        )
        if rtn_mnu == 1:
            Start()
        else:
            print(" ")
            print(Fore.LIGHTBLUE_EX + "\tThank You for Using Contact Book :)")
            sleep(5)
            print(" ")
    except:
        print(" ")
        print(Fore.LIGHTRED_EX + "\tYou Put Wrong Number :()")
        sleep(5)
        print(" ")


Start()
