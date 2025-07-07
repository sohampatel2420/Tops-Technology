class ATM :
    def __init__(self):
        self.pin=""
        self.bal=0
        self.create_pin()
        self.menu()
        
    def menu(self):
        user_inp= input('''
        Hello,
        Tamari seva ma tatpar chhiye,
              1. press 1 >  Paisa nakhva mate
              2. press 2 >  Pin badalva
              3. press 3 >  Balance check karva
              4. press 4 >  Paisa upadva mate
              5. press 5 >  Exit
        ''')

        
        if user_inp == "1" :
            self.money_deposit()
        elif user_inp == "2" :
            self.chage_pin()
        elif user_inp == "3" :
            self.check_bal()
        elif user_inp == "4" :
            self.money_Withdraw()
        else:
            exit()


    def create_pin(self):
        user_inp=input('''
        Welcome to Flash ATM.
        First enter the credit or debit card and create the PIN for your credit or debit card..

        Enter Your PIN :''')
        self.pin=user_inp
        print("PIN is created..")
        self.menu()

    def money_deposit(self):
        user_inp=input("Enter the PIN :")
        if user_inp == self.pin:
            user_money=int(input("Enter the amount :"))
            self.bal+=user_money
            print("Transection successfull...")
            self.menu()
        else:
            print("Wrong PIN....")
            self.menu()
    
    def chage_pin(self):
        user_inp=input("Enter the old PIN :")
        if user_inp==self.pin:
            new_pin=input("Enter the new PIN :")
            self.pin=new_pin
            print("PIN was changed...")
            self.menu()
        else:
            print("Wrong PIN....")
            self.menu()

    def check_bal(self):
        user_inp=input("Enter the PIN:")
        if user_inp==self.pin:
            print(f"Your corrunt balance : {self.bal}")
            self.menu()
        else:
            print("Wrong PIN...")
            self.menu()
    
    def money_Withdraw(self):
        try:
            user_inp=input("Enter the PIN:")
            if user_inp==self.pin:  
                print(f"Your corrunt balance is : {self.bal}")
                user_money=int(input("Enter the money :"))
                if user_money>self.bal:
                    raise ValueError("Your amount is more then balance..")
                else:
                    self.bal-=user_money
                    print("Successful..")
                    self.menu()
            else:
                print("Wrong PIN...")
                self.menu()

        except ValueError:
            print("Your written amount is more then balance. So you plz try again")
            self.money_Withdraw()            

a=ATM()