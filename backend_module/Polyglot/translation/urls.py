from django.urls import path
from .views import translate, index  # Import the translate view

urlpatterns = [
    path('', index, name='index'),
    path('api/translate/', translate, name='translate'),  # Define the URL pattern for the translate view
]
