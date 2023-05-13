from django.urls import path
from .views import Student_List
from .views import Course_List

urlpatterns = [
    path('students/',Student_List),
    path('course/',Course_List),
]