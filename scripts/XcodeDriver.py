#!/usr/bin/env python

import os, sys

import subprocess

class XcodeDriver:
    BaseDirKey  = 'baseDir'
    ProjectsKey = 'projects'

    ProjectNameKey   = 'name'
    ProjectSchemeKey = 'scheme'
    ProjectSDKKey    = 'sdk'

    def __init__(self, config):
        self.baseDir = None
        if config.has_key(self.BaseDirKey):
            self.baseDir = config[self.BaseDirKey]
        else:
            print('XCODE_DRIVER: Missing %s' % self.BaseDirKey)
        self.projects = []
        if config.has_key(self.ProjectsKey):
            self.projects = config[self.ProjectsKey]
            if not self._verifyProjects(self.projects):
                print('XCODE_DRIVER: Projects key misconfigured')
        else:
            print('XCODE_DRIVER: Missing %s' % self.BaseDirKey)

    def _verifyProjects(self, projects):
        lastName = None
        misconfigure = False
        for proj in projects:
            if not proj.has_key(self.ProjectNameKey) or \
            not proj.has_key(self.ProjectSchemeKey) or \
            not proj.has_key(self.ProjectSDKKey):
                print('XCODE_DRIVER: misconfiguration on or after %s' % lastName)
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
        popenArgs = ['xcodebuild',
                     '-project', os.path.expanduser(projDir),
                     '-scheme',  projectArgs[self.ProjectSchemeKey],
                     '-sdk',     projectArgs[self.ProjectSDKKey]]
        print('XCODE_DRIVER: Running build for %s' % projDir)
        result = 0
        try:
            result = subprocess.check_call(popenArgs)
        except subprocess.CalledProcessError, e:
            result = e.returncode
        return result
