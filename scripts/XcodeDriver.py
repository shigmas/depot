#!/usr/bin/env python

import os, sys

import subprocess

class XcodeDriver:
    ProjectsKey = 'projects'

    ProjectNameKey   = 'name'
    ProjectSchemeKey = 'scheme'
    ProjectTypeKey   = 'type'
    ProjectSDKKey    = 'sdk'

    def __init__(self, config, baseDir, sdk, arch, isRelease=False):
        self.baseDir = baseDir
        self.isRelease = isRelease
        self.sdk = sdk
        self.arch = arch

        self.projects = []
        if config.has_key(self.ProjectsKey):
            self.projects = config[self.ProjectsKey]
            if not self._verifyProjects(self.projects):
                print('XCODE_DRIVER: Projects key misconfigured')
        else:
            print('XCODE_DRIVER: Missing %s' % self.ProjectsKeys)

    def _verifyProjects(self, projects):
        lastName = None
        misconfigure = False
        for proj in projects:
            if not proj.has_key(self.ProjectNameKey):
                print('XCODE_DRIVER: missing %s after %s' % (self.ProjectNameKey,
                                                             lastName))
                misconfigure = True
            if not proj.has_key(self.ProjectSchemeKey) and \
               not proj.has_key(self.ProjectTypeKey):
                print('XCODE_DRIVER: missing %s and %s after %s' % (self.ProjectSchemeKey,
                                                                    self.ProjectTypeKey,
                                                                    lastName))
                misconfigure = True
            else:
                lastName = proj[self.ProjectNameKey]
            if misconfigure:
                return False

        return True
                
    def build(self):
        numProjs = len(self.projects)
        completed = 0
        for proj in self.projects:
            retCode = self._runBuild(proj)
            if retCode != 0:
                print('XCODE_DRIVER: Build failed with %d' % retCode)
                break
            else:
                completed = completed + 1
        print ("XCODE_DRIVER: %d of %d builds completed successfully" %
               (completed, numProjs))

    def _runBuild(self, projectArgs):
        projDir = os.path.join(self.baseDir, projectArgs[self.ProjectNameKey])

        # use scheme if present, else, use type with the release keyword.
        if projectArgs.has_key(self.ProjectSchemeKey):
            scheme = projectArgs[self.ProjectSchemeKey]
        else:
            if self.isRelease:
                scheme = 'Release%s' % projectArgs[self.ProjectTypeKey]
            else:
                scheme = projectArgs[self.ProjectTypeKey]


        # Somehow, I wonder if we can do this for local builds:
        # xcodebuild VALID_ARCHS='x86_64 armv7' ONLY_ACTIVE_ARCH=NO -project ~/src/tree/futomen/core/FFKit/FFKit.xcodeproj -scheme Framework
        # or
        # xcodebuild ONLY_ACTIVE_ARCH=NO VALID_ARCHS='armv7 x86_64' -project /Users/wyan/src/tree/futomen/libs/AFNetworking/AFNetworking.xcodeproj -scheme Framework -sdk iphonesimulator8.4
        # to build for the simulator *and* device.
        if self.arch:
            if len(self.arch) == 1:
                popenArgs = ['xcodebuild',
                             '-project', os.path.expanduser(projDir),
                             '-scheme',  scheme,
                             '-arch',    self.arch[0],
                             '-sdk',     self.sdk]
            else:
                archs = ' '.join(self.arch)
                popenArgs = ['xcodebuild',
                             # no single quotes when running as a script
                             'VALID_ARCHS=%s' % archs,
                             'ONLY_ACTIVE_ARCH=NO',
                             '-project', os.path.expanduser(projDir),
                             '-scheme',  scheme]
        else:
            popenArgs = ['xcodebuild',
                         '-project', os.path.expanduser(projDir),
                         '-scheme',  scheme,
                         '-sdk',     self.sdk]
        print('XCODE_DRIVER: Running build for %s with args %s' % (projDir,popenArgs))
        result = 0

        try:
            result = subprocess.check_call(popenArgs)
        except subprocess.CalledProcessError, e:
            result = e.returncode
        return result
