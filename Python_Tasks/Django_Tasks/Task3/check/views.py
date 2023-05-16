from django.shortcuts import render
from .models import Signup
from .forms import Signup_Form
from django.http import HttpResponseRedirect


def SignUp_Submit(request):
    if request.method == 'POST':
        myinfo = Signup_Form(request.POST)

        if myinfo.is_valid():
            myinfo.save()

            return HttpResponseRedirect("/Myinfo/")
        
        else:
            return render(request,'SignUp.html',{'myform':myinfo})

    else:
        myinfo = Signup_Form(None)
        return render(request,'SignUp.html',{'myform':myinfo})


def signup_list(request):
    myform = Signup.objects.all()
    return render(request,'Myinfo.html',{'myform':myform})

