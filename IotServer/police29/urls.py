from django.urls import path, include
from police29 import views

urlpatterns = [
    path('', views.get_firebase_images, name='index')
]
