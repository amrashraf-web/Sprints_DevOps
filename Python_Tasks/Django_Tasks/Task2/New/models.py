from django.db import models


class Student(models.Model):
    name = models.CharField(max_length=200)
    age = models.IntegerField(max_length=3)
    grade = models.CharField(max_length=20)
    phone = models.IntegerField(max_length=11)
    gender = models.CharField(max_length=6)


class Courses(models.Model):
    name = models.CharField(max_length=200)
    Subscription = models.IntegerField(max_length=3)
    type_of = models.CharField(max_length=200)

