from django.urls import path
from . import views

urlpatterns = [
    path('MyCv/',views.MyCv,name='MyCv'),
]