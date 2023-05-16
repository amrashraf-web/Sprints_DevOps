from django.forms import ModelForm
from .models import Signup


class Signup_Form(ModelForm):
    class Meta:
        model = Signup
        fields = "__all__"

    def clean(self):
        super(Signup_Form,self).clean()
        Name = self.cleaned_data.get('Name')
        Email = self.cleaned_data.get('Email')
        Phone = self.cleaned_data.get('Phone')

        if len(Name) < 5:
            self._errors['Name'] = self.error_class(['Minimum 5 characters required'])

        if len(Email) < 10:
            self._errors['Email'] = self.error_class(['Minimum 10 characters required'])

        if len(str(Phone)) <= 11:
            self._errors['Phone'] = self.error_class(['Minimum 11 Numbers required'])
        return self.cleaned_data