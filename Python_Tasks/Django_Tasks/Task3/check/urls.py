from .views import signup_list,SignUp_Submit
from django.urls import path

urlpatterns = [
    path('SignUp/',SignUp_Submit,name='SignUp'),
    path('Myinfo/',signup_list,name='MyInformation'),
]