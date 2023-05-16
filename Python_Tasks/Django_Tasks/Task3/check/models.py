from django.db import models

class Signup(models.Model):
    Name = models.CharField(max_length=200,null=False)
    Email = models.CharField(max_length=200,null=False)
    Phone = models.IntegerField(null=False)
    Gender = models.CharField(max_length=6, choices=(('Male','Male'),('Female','Female')), default='Male')
    Time = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.Name
    


    