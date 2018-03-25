# -*- coding: utf-8 -*-
# Generated by Django 1.11.8 on 2018-03-22 18:43
from __future__ import unicode_literals

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('indigo_api', '0035_amendments'),
    ]

    operations = [
        migrations.CreateModel(
            name='Work',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('frbr_uri', models.CharField(max_length=512, null=False, unique=True, help_text="Used globally to identify this work")),
                ('title', models.CharField(default=b'(untitled)', max_length=1024, null=True)),
                ('country', models.CharField(default=b'za', max_length=2)),
                ('publication_name', models.CharField(null=True, max_length=255, help_text="Original publication, eg. government gazette")),
                ('publication_number', models.CharField(null=True, max_length=255, help_text="Publication's sequence number, eg. gazette number")),
                ('publication_date', models.CharField(null=True, max_length=255, help_text="Date of publication (YYYY-MM-DD)")),
                ('draft', models.BooleanField(default=True, help_text=b"Drafts aren't available through the public API")),
                ('deleted', models.BooleanField(default=False, help_text=b'Has this work been deleted?')),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True)),
                ('created_by_user', models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='+', to=settings.AUTH_USER_MODEL)),
                ('updated_by_user', models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='+', to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]
