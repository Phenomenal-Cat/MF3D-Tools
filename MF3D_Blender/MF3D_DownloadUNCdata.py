#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jun 10 17:18:15 2020

@author: aidan
"""
import girder_client

Destination = '/Volumes/Seagate Backup 3/'
Folder = '553e6db18d777f082b5918eb'
gc = girder_client.GirderClient(apiUrl='https://data.kitware.com/api/v1')
gc.authenticate(username='anonymous', interactive=True)
#gc.inheritAccessControlRecursive(UNC_ScanURL)

#gc.downloadFile(fileId=FileID, path=Destination)

#
#
#URL = 'anonymous@data.kitware.com:collection/UNC-Wisconsin\ Neurodevelopment\ Rhesus\ Data/scan_data'