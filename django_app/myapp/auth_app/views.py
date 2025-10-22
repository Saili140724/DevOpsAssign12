

# Create your views here.
from django.shortcuts import render, redirect
from django.contrib import messages
from .models import Login

def login_view(request):
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']
        try:
            user = Login.objects.get(username=username, password=password)
            return render(request, 'home.html', {'username': user.username})
        except Login.DoesNotExist:
            messages.error(request, 'Invalid credentials')
    return render(request, 'login.html')

def register_view(request):
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']
        if Login.objects.filter(username=username).exists():
            messages.error(request, 'Username already exists')
        else:
            Login.objects.create(username=username, password=password)
            messages.success(request, 'Registered successfully')
            return redirect('login')
    return render(request, 'register.html')

def logout_view(request):
    return redirect('login')
