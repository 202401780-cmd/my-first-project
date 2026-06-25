from django.urls import path
from . import views
from .views import RegisterView

urlpatterns = [
    path('login/', views.login_user, name='login'),
    path('register/', RegisterView.as_view(), name='register'),
]