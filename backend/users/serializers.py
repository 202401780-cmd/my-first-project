from rest_framework import serializers
from .models import UserProfile
from django.contrib.auth.hashers import make_password

class RegistrationSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserProfile
        fields = ['username', 'password']
        extra_kwargs = {
            'password': {'write_only': True}
        }

    def create(self, validated_data):
        validated_data['password'] = make_password(validated_data['password'])
        return UserProfile.objects.create(**validated_data)