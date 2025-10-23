

from django.shortcuts import render, redirect
from django.contrib import messages
from .models import Login

# 🏠 Home page
def home(request):
    # Get username from session if user is logged in
    username = request.session.get('username', None)
    return render(request, 'home.html', {'username': username})

# 🔐 Login page
def login_view(request):
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']

        try:
            # Check if user exists
            user = Login.objects.get(username=username, password=password)
            # Store username in session
            request.session['username'] = user.username
            messages.success(request, f'Welcome {user.username}!')
            return redirect('home')
        except Login.DoesNotExist:
            messages.error(request, 'Invalid username or password')

    return render(request, 'login.html')

# 📝 Register page
def register_view(request):
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']

        # Check if username already exists
        if Login.objects.filter(username=username).exists():
            messages.error(request, 'Username already exists')
        else:
            Login.objects.create(username=username, password=password)
            messages.success(request, 'Registration successful! Please log in.')
            return redirect('login')

    return render(request, 'register.html')

# 🚪 Logout
def logout_view(request):
    # Clear session data
    request.session.flush()
    messages.success(request, 'You have been logged out successfully.')
    return redirect('login')
