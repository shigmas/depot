#!/usr/bin/env python3

import json
import http.client
import os
import sys

import argparse

class ClubhouseClient:
    # Hardcoded Software Team's Workflow ID
    SoftwareWorkflowId = 500000019

    def make_request(self, url, append=False, bodyDict=None):
        headers = {'Content-Type':'application/json'}
        token = os.getenv('CLUBHOUSE_API_TOKEN')

        host = 'api.clubhouse.io'
        if append:
            url = '%s&token=%s' % (url, token)
        else:
            url = '%s?token=%s' % (url, token)

        conn = http.client.HTTPSConnection('api.clubhouse.io')
        jsonDict = None
        if bodyDict is not None:
            jsonDict = json.dumps(bodyDict)
        #print('url: [%s] (data: %s)' % (url, jsonDict))
        resp = conn.request('GET', url, jsonDict, headers)
        if resp is None:
            resp = conn.getresponse()

        return resp.read()

    # For smaller lists of things from clubhouse, like members or
    # workflows. This assumes indexed by a key called 'id'
    def get_generic_dictionary(self, url, idKey='id'):
        rawJson = self.make_request(url)
        elemArray = json.loads(rawJson)
        elemsById = {}
        # Iterate so we can store by memberId
        for elem in elemArray:
            #print('indexing by %s' % member['id'])
            elemsById[elem[idKey]] = elem

        return elemsById
    
class GlobalParser(ClubhouseClient):
    MembersUrl = '/api/v2/members'
    WorkflowsUrl = '/api/v2/workflows'
    
    def __init__(self):
        self.__members = {}
        self.__workflows = {}
        self.populate()

    def populate(self):
        self.__members = self.get_generic_dictionary(self.MembersUrl)
        self.__workflows = self.get_generic_dictionary(self.WorkflowsUrl)

    def is_user_id(self, user_id_candidate):
        return user_id_candidate in self.__members.keys()

    def get_id_from_mention(self, mention_name):
        for member in self.__members.values():
            if member['profile']['mention_name'] == mention_name:
                return member['id']

        return None

    def get_mention_name(self, mem_id):
        member = self.__members.get(mem_id)
        if member is None:
            print('no member with id %s' % mem_id)
            return ''

        # the name is actually in the profile
        profile = member['profile']
        return member['profile']['mention_name']

    def get_workflow_state_name(self, workflow_state_id):
        workflow = self.__workflows.get(self.SoftwareWorkflowId)
        if workflow is None:
            print('no workflow with id %s' % self.SoftwareWorkflowId)
            return ""

        for state in workflow['states']:
            if state['id'] == workflow_state_id:
                return state['name']

        return ''

    def print_users(self):
        for member in self.__members.values():
            profile = member['profile']

            print('%s %s %s' % (member['id'], profile['name'],
                                profile['mention_name']))

    def print_workflow_states(self):
        for state in self.__workflows.values():
            print('%d %s' % (member['id'], member['name']))


class EpicParser(ClubhouseClient):
    SearchStoriesUrl = '/api/v2/search/stories'
    # More flexible to pull from the JSON in GlobalParser, but we'd still have
    # to key off the name.
    UnfinishedStates = [500000022, 500000021, 500000020,]

    def __init__(self, filter_incomplete=True):
        self.__filter_incomplete = filter_incomplete
        self.__story_data = {}

    def parse_epic(self, epic_id, verbose=True):
        updated = self.get_story_data(epic_id,verbose)
        #print('parsed %d stories' % len(updated))
        self.__story_data.update(updated)
        #print('total %d stories' % len(self.__story_data))
                    
    def index_and_filter_stories(self, storyList):
        storyDict = {}
        for story in storyList:
            storyId = story['id']
            workflow_state_id = story['workflow_state_id']
            if self.__filter_incomplete and \
               workflow_state_id not in self.UnfinishedStates:
                continue
            storyDict[storyId] = story

        return storyDict

    def get_story_data(self, epic, verbose=True):
        queryString = 'epic:%s' % epic
        bodyDict = {"query":queryString}

        rawJson = self.make_request(self.SearchStoriesUrl, False, bodyDict)
        storyData = {}
        dataToFetch = True

        if verbose:
            print('Fetching %d ' % epic, end='')
        while dataToFetch:
            if verbose:
                print('.', end='')
            sys.stdout.flush()
            jsonData = json.loads(rawJson)
            nextUrl = None
            if jsonData.get('message'):
                print('message: %s' % jsonData['message'])
                dataToFetch = False
            else:
                nextUrl = jsonData['next']
                storyBatch = jsonData['data']
                storyDict = self.index_and_filter_stories(storyBatch)
                storyData.update(storyDict)

            if nextUrl:
                # not sure if we need to pass the dictionary in again.
                bodyDict['next'] = nextUrl
                rawJson = self.make_request(nextUrl, True)
            else:
                dataToFetch = False
        if verbose:
            print()

        return storyData

    def get_unassigned(self):
        unassigned = []

        for story in self.__story_data.values():
            owners = story['owner_ids']
            if owners is None or len(owners) == 0:
                unassigned.append(story['id'])

        return unassigned

    def get_multiple_owners(self):
        multiple = []

        for story in self.__story_data.values():
            owners = story['owner_ids']
            if owners is not None and len(owners) > 1:
                multiple.append(story['id'])

        return multiple

    def get_time_estimates(self, user_id=None):
        user_times = {}
        user_unestimated = {}
        estimated_stories = []
        unEstimatedStories = []
        unowned = []
        for story in self.__story_data.values():
            owners = story['owner_ids']
            estimate = story['estimate']
            #  This will add the count just to the first owner
            if owners is None or len(owners) == 0:
                #print('no owners for %d' % story['id'])
                unowned.append(story['id'])
                continue
            elif len(owners) > 1:
                print('multiple owners for story [%d]' % story['id'])
                continue
            elif user_id is None or user_id == owners[0]:
                current_time = 0
                if estimate is not None:
                    estimated_stories.append(story['id'])
                    if user_times.get(owners[0]) is not None:
                        current_time = user_times[owners[0]]
                    user_times[owners[0]] = current_time + estimate
                else:
                    unEstimatedStories.append(story['id'])
                    if user_unestimated.get(owners[0]) is not None:
                        user_unestimated[owners[0]].append(story['id'])
                    else:
                        user_unestimated[owners[0]] = [story['id']]
        #print('stories with estimates: %d %s' % (len(estimated_stories),
        #                                         estimated_stories))
        #print('stories without estimates: %d %s' % (len(unEstimatedStories),
        #                                            unEstimatedStories))
        #print('unowned stories: %d %s' % (len(unowned), unowned))
        return user_times, user_unestimated, estimated_stories
 
    def print_story_keys(self, global_data, storyKeys):
        for story in self.__story_data.values():
            storyLine = ""
            for storyKey in storyKeys:
                try:
                    value = story[storyKey]
                    if storyKey == 'owner_ids':
                        value = global_data.get_mention_name([value])
                    elif storyKey == 'workflow_state_id':
                        value = global_data.get_workflow_state_name(value)
                    storyLine += ('%s: %s ' % (storyKey, value))
                except KeyError:
                    print('no %s found. Here are the keys: %s' % (storyKey,
                                                                  story.keys()))
            print(storyLine)

        return

def print_list(message, stories):
    if message is not None:
        print(message)

    print('[ ', end='')
    for storyId in stories:
        print('%s ' % storyId, end='')
    print(']')
    return

def print_dict(globalVals, key, message, stories):
    print(message)

    if key == 'users':
        for mem_id in stories.keys():
            val = stories[mem_id]
            if type(val) is list:
                print('%s: ' % globalVals.get_mention_name(mem_id), end='')
                print_list(None, val)
            else:
                print('%s: %s' % (globalVals.get_mention_name(mem_id), val))

def get_epics_from_arg(cli_arg):
    try:
        return [int(cli_arg)]
    except ValueError: # cli_arg is a comma separated list
        # just continue
        pass
    epicStrings = cli_arg.split(',')
    try:
        return [int(es) for es in epicStrings]
    except ValueError:
        print('Epic argument is not an id or list of ids')

    return []

def main():
    parser = argparse.ArgumentParser()
    group = parser.add_mutually_exclusive_group()
    group.add_argument('-d','--display', #type=string, (default)
                       choices=['users','states'],
                       help='Print [users] or workflow [states]')
    group.add_argument('-n','--unassigned', action="store_true",
                       help='Show unassigned tasks')
    group.add_argument('-m','--multiple_owners', action="store_true",
                       help='Show stories with multiple owners')
    group.add_argument('-s','--summary', action='store_true',
                       help='Get the estimates for all users, enumerating unestimated')
    group.add_argument('-u','--user', #type=int,
                       help='Get the details for the user ID')
    parser.add_argument('-v','--verbose', action="store_true",
                        help='Show progress')
    parser.add_argument('--incomplete','-i', action="store_true",
                        help='Filter to show only incomplete stories')
    parser.add_argument('epic_ids', #type=int,
                        help='Epic ID (ID or comma separate IDs')
    args = parser.parse_args()

    globalVals = GlobalParser()

    if args.display:
        if args.display == 'users':
            globalVals.print_users()
        elif args.display == 'states':
            globalVals.print_workflow_states()
        sys.exit()

    epic_ids = get_epics_from_arg(args.epic_ids)
    if len(epic_ids) == 0:
        sys.exit(-1)

    if args.verbose:
        adj = "all"
        if args.incomplete:
            adj ='uncompleted'
        print('fetching %s stories.' % adj)

    epicParser = EpicParser(args.incomplete)
    for epic_id in epic_ids:
        epicParser.parse_epic(epic_id, args.verbose)

    if args.unassigned:
        unassigned_ids = epicParser.get_unassigned()
        print_list('Unassigned story ID\'s:', unassigned_ids)
    elif args.multiple_owners:
        multiple_ids = epicParser.get_multiple_owners()
        print_list('multiple owner story ID\'s:', multiple_ids)
    elif args.summary:
        user_est, user_unest, _ = epicParser.get_time_estimates()
        print_dict(globalVals, 'users', 'User\'s estimated points:',
                   user_est)
        print_dict(globalVals, 'users', 'User\'s unestimated stories:',
                   user_unest)
    elif args.user is not None:
        user_id = args.user
        mention_name = ''
        if globalVals.is_user_id(user_id):
            # Maybe its a mention. (user names have spaces, and we don't handle that?)
            # If we still can't find it, we do 'all'
            globalVals.get_mention_name(user_id)
        else:                   # mention name
            mention_name = user_id
            user_id = globalVals.get_id_from_mention(mention_name)
        if user_id is not None:
            user_est, user_unest, story_list = epicParser.get_time_estimates(user_id)
            print_list('%s\'s estimated stories:' % mention_name, story_list)
            print_dict(globalVals, 'users', 'Users\'s estimated points:',
                       user_est)
            print_dict(globalVals, 'users', 'User\'s stories without estimates:',
                       user_unest)

if __name__ == '__main__':
    main()
