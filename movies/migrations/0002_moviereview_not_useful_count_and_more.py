# Generated by Django 5.0.4 on 2024-05-24 17:06

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('movies', '0001_initial'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.AddField(
            model_name='moviereview',
            name='not_useful_count',
            field=models.IntegerField(default=0),
        ),
        migrations.AddField(
            model_name='moviereview',
            name='useful_count',
            field=models.IntegerField(default=0),
        ),
        migrations.CreateModel(
            name='ReviewVote',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('vote', models.IntegerField()),
                ('review', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='movies.moviereview')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'unique_together': {('user', 'review')},
            },
        ),
    ]