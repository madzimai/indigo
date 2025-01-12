# -*- coding: utf-8 -*-
# Generated by Django 1.11.20 on 2019-05-10 20:07
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('indigo_metrics', '0002_dailyworkmetrics'),
    ]

    operations = [
        migrations.AddField(
            model_name='workmetrics',
            name='p_breadth_complete',
            field=models.IntegerField(help_text=b'Percentage breadth complete', null=True),
        ),
        migrations.AddField(
            model_name='workmetrics',
            name='p_complete',
            field=models.IntegerField(help_text=b'Percentage complete', null=True),
        ),
        migrations.AddField(
            model_name='workmetrics',
            name='p_depth_complete',
            field=models.IntegerField(help_text=b'Percentage depth complete', null=True),
        ),
    ]
