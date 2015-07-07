#!/usr/bin/env python

"""
  build.py <parameters>

  Script to build a series of xcode projects.  the config specifies the
  projects, with the name being the xcode project based of a base directory
  which is passed in on the command line.

  parameters:
  -b, --base [dir] (required)
     base directory.  Full path to the root of the projects directory

  -r, --release
     If this is a release build.  Default is no

  -s, --sdk
     The sdk that we pass on to the build.  'xcodebuild -showsdks' to see list

  -a, --arch
     The architecture we pass on to the build.  This is optional, and omitting it
     will leave it to the scheme.  Only one architecture can be specified at a
     time, but the flag can be used multiple times.

  -?, --help
     This message

"""
import os, sys
import getopt, types

# Easiest way to have a config is with a dictionary.  And since python
# dictionaries are human readable, we just make this python file the config
# file

DefaultSDK = 'iphonesimulator8.4'

# Since we generally build one set of these at a time
FrameworkType = 'Framework'
ResourcesType = 'Resources'

config = {
    'projects': [
        {
            'name' : 'libs/AFNetworking/AFNetworking.xcodeproj',
            'type' : FrameworkType,
        },
        {
            'name' : 'libs/HRColorPicker/HRColorPicker.xcodeproj',
            'type' : FrameworkType,
        },
        {
            'name' : 'libs/SVProgressHUD/SVProgressHUD.xcodeproj',
            'type' : FrameworkType,
        },
        {
            'name' : 'libs/SVProgressHUD/SVProgressHUD.xcodeproj',
            'type' : ResourcesType,
        },
        {
            'name' : 'core/FFKit/FFKit.xcodeproj',
            'type' : FrameworkType,
        },
        {
            'name' : 'core/FANG/FANG.xcodeproj',
            'type' : FrameworkType,
        },
        {
            'name' : 'core/FLogKit/FLogKit.xcodeproj',
            'type' : FrameworkType,
        },
        {
            'name' : 'core/FUIKit/FUIKit.xcodeproj',
            'type' : FrameworkType,
        },
        {
            'name' : 'core/FUIKit/FUIKit.xcodeproj',
            'type' : ResourcesType,
        },
        {
            'name' : 'core/FGLKit/FGLKit.xcodeproj',
            'type' : FrameworkType,
        },
        {
            'name' : 'core/FPrim/FPrim.xcodeproj',
            'type' : FrameworkType,
        },
        {
            'name' : 'core/FCache/FCache.xcodeproj',
            'type' : FrameworkType,
        },
        {
            'name' : 'libs/GLUKit/GLUKit.xcodeproj',
            'type' : FrameworkType,
        },
        {
            'name' : 'libs/FAPKit/FAPKit.xcodeproj',
            'type' : FrameworkType,
        },
        {
            'name' : 'libs/FAPKit/FAPKit.xcodeproj',
            'type' : ResourcesType,
        },
        {
            'name'   : 'apps/ios/MaltMap/MaltMap.xcodeproj',
            'scheme' : 'MaltMap',
        },
    ]
}

def usage(why=None):
    if (why):
        print('Error: %s'% why)
    print __doc__

def parseArgs(argv):
    SHORT_ARGS = '?b:rt:a:s:'
    LONG_ARGS = ['help','base:','release','arch:', 'sdk:']
    isRelease = False
    baseDir = None
    arch = None
    sdk = None

    try:
        arglist, args = getopt.getopt(argv[1:],SHORT_ARGS, LONG_ARGS)
    except getopt.error, why:
        usage(why)
        sys.exit()

    try:
        for (field, val) in arglist:
            if field == '--help' or field == '-?':
                usage()
                sys.exit()
            if field == '--base' or field == '-b':
                baseDir = val
            elif field == '--release' or field == '-r':
                isRelease = True
            elif field == '--sdk' or field == '-s':
                sdk = val
            elif field == '--arch' or field == '-a':
                if type(arch) is types.NoneType: 
                    arch = [val]
                else:
                    arch.append(val)
    except ValueError:
        usage('Invalid parameter %s' % field)
        sys.exit()

    print('arch: %s' % arch)

    return baseDir, isRelease, sdk, arch


def main(args, stdout, environ):

    baseDir, isRelease, sdk, arch = parseArgs(args)

    # verify the arguments
    if baseDir is None:
        usage(why='base directory not specified')
        sys.exit()

    if sdk is None:
        sdk = DefaultSDK

    import XcodeDriver
    print('args to driver: base: %s release: %s, sdk: %s, arch: %s' % (baseDir,
                                                                       isRelease,
                                                                       sdk,
                                                                       arch))

    s = XcodeDriver.XcodeDriver(config, baseDir, sdk, arch, isRelease)
    s.build()

if __name__ == '__main__':
    main(sys.argv, sys.stdout, os.environ)
