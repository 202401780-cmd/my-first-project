from rest_framework import serializers
from .models import UserProfile

class RegistrationSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = UserProfile
        fields = ['username', 'password']

    def create(self, validated_data):
        user = UserProfile.objects.create(
            username=validated_data['username'],
            password=validated_data['password']
        )
        return user