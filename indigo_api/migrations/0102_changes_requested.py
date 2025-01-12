# -*- coding: utf-8 -*-
# Generated by Django 1.11.18 on 2019-06-11 09:40
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('indigo_api', '0101_taxonomies'),
    ]

    operations = [
        migrations.AlterModelOptions(
            name='attachment',
            options={'ordering': ('filename',)},
        ),
        migrations.AlterModelOptions(
            name='documentactivity',
            options={'ordering': ('created_at',)},
        ),
        migrations.AlterModelOptions(
            name='subtype',
            options={'ordering': ('name',), 'verbose_name': 'Document subtype'},
        ),
        migrations.AlterModelOptions(
            name='workflow',
            options={'ordering': ('title',), 'permissions': (('close_workflow', 'Can close a workflow'),)},
        ),
        migrations.AddField(
            model_name='task',
            name='changes_requested',
            field=models.BooleanField(default=False, help_text=b'Have changes been requested on this task?'),
        ),
    ]
