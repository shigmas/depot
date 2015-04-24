#!/usr/bin/env python

# Easiest way to have a config is with a dictionary.  And since python
# dictionaries are human readable, we just make this python file the config
# file

# Since we generally build one set of these at a time
FrameworkScheme = 'ReleaseFramework'
ResourcesScheme = 'ReleaseResources'
Sdk = 'iphoneos8.2'

config = {
    'baseDir': '~/src/tree/futomen',
    'projects': [
        {
            'name'   : 'core/FFKit/FFKit.xcodeproj',
            'scheme' : FrameworkScheme,
            'sdk'    : Sdk,
        },
        {
            'name'   : 'core/FUIKit/FUIKit.xcodeproj',
            'scheme' : FrameworkScheme,
            'sdk'    : Sdk,
        },
        {
            'name'   : 'core/FUIKit/FUIKit.xcodeproj',
            'scheme' : ResourcesScheme,
            'sdk'    : Sdk,
        },
        {
            'name'   : 'core/FGLKit/FGLKit.xcodeproj',
            'scheme' : FrameworkScheme,
            'sdk'    : Sdk,
        },
        {
            'name'   : 'core/FPrim/FPrim.xcodeproj',
            'scheme' : FrameworkScheme,
            'sdk'    : Sdk,
        },
    ]
}


import XcodeDriver

s = XcodeDriver.XcodeDriver(config)
s.build()
