from colorama import Fore
"""
Open Brackets =  ( , { , [ 
Closed Brackets = ) , } , ]
"""
# Function to Check The String
def isBalanced(String):
    # I Used Brackets as empty list to keep track of the opening brackets
    Brackets = []
    # Make Loop through each character in the string
    for char in String:
        # If the character is an opening bracket so append it to Brackets List
        if char in '({[':
            Brackets.append(char)
        # Elif the character is an Closed bracket so append it to Brackets List
        elif char in ')}]':
            # We Should pop the top element from the Brackets List  and check if it matches the corresponding opening bracket
            if not Brackets:
                return False
            elif char == ')' and Brackets[-1] == '(':
                Brackets.pop()
            elif char == '}' and Brackets[-1] == '{':
                Brackets.pop()
            elif char == ']' and Brackets[-1] == '[':
                Brackets.pop()
            else:
                return False
    # Mean the sequence is balanced.
    if not Brackets:
        return True
    # Mean  the sequence is not balanced.
    else:
        return False
# Taking The Number Of Strings Which The User Will Check Them  + The Number Should Be Integer So i Use int Function
Number = int(input(Fore.LIGHTWHITE_EX +
             "[+] Enter The Number Of Strings : ").strip())
# Here I Made A loop For Number Of Strings To Check Each String If Balanced Or Not Then Go To Check The Next String
for k in range(Number):
    # I Ask The User To Put The String That Will Check It.
    string_input = input(Fore.LIGHTWHITE_EX + "[+] Enter Your String : ")
    # Here I Call The Function isBalanced With Passing The Input String in It to Check the String Condition
    if isBalanced(string_input) == True:
        print(Fore.LIGHTGREEN_EX + "\t\tYes")
    else:
        print(Fore.LIGHTRED_EX + "\t\tNo")
