from django import forms

class NameForm(forms.Form):
    your_name = forms.CharField(label="Nombre", max_length=100, help_text="100 car. máximo", 
                                    error_messages={"required": "El nombre es obligatorio"},
                                    widget=forms.Textarea(attrs={"class":"text-gray-400", "rows": 3, "cols": 60}))
                                    
from .models import MovieReview

class MovieReviewForm(forms.ModelForm):
    class Meta:
        model = MovieReview
        fields = ['rating', 'review']