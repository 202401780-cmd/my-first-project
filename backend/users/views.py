from django.contrib.auth import authenticate
from django.http import JsonResponse
import json
from django.views.decorators.csrf import csrf_exempt

@csrf_exempt
def login_user(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            username = data.get('username')
            password = data.get('password')
            
            # التأكد من اسم المستخدم والباسورد في قاعدة البيانات PostgreSQL
            user = authenticate(username=username, password=password)
            
            if user is not None:
                return JsonResponse({
                    'status': 'success',
                    'message': 'Login successful',
                    'user': user.username
                }, status=200)
            else:
                return JsonResponse({
                    'status': 'error',
                    'message': 'Invalid username or password'
                }, status=400)
                
        except Exception as e:
            return JsonResponse({'status': 'error', 'message': str(e)}, status=400)
            
    return JsonResponse({'status': 'error', 'message': 'Only POST method allowed'}, status=405)
