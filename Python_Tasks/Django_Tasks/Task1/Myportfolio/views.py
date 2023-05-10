from django.http import HttpResponse
from django.template import loader
from django.shortcuts import render
def MyCv(request):
    return render(request,'CV.html')
