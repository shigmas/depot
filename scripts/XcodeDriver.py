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

        
        if self.sdk:
            popenArgs = ['xcodebuild',
                         '-project', os.path.expanduser(projDir),
                         '-scheme',  scheme,
                         '-arch',    self.arch,
                         '-sdk',     self.sdk]
        else:
            popenArgs = ['xcodebuild',
                         '-project', os.path.expanduser(projDir),
                         '-scheme',  scheme,
                         '-arch',    self.arch,
                         '-sdk',     self.sdk]
        print('XCODE_DRIVER: Running build for %s with args %s' % (projDir,popenArgs))
        result = 0
        try:
            result = subprocess.check_call(popenArgs)
        except subprocess.CalledProcessError, e:
            result = e.returncode
        return result
