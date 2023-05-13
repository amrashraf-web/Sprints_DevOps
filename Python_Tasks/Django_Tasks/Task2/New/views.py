from django.shortcuts import render
from .models import Student,Courses


def Student_List(request):
    Studen_Details = Student.objects.all()
    return render(request,'student.html',{'Std':Studen_Details})


def Course_List(request):
    Courses_Details = Courses.objects.all()
    return render(request,'course.html',{'Ctd':Courses_Details})