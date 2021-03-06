#!/usr/bin/env python

import datetime
import logging
import os    
import subprocess
import sys

# Get rid of that annoying
# InsecureRequestWarning: Unverified HTTPS request is being made.
# message
#import requests
#requests.packages.urllib3.disable_warnings()

__author__ = 'Erinn Looney-Triggs'
__credits__ = ['Erinn Looney-Triggs', 'Justin Ellison', 'Harald Jensas' ]
__license__ = 'GPL 3.0'
__maintainer__ = 'Erinn Looney-Triggs'
__email__ = 'erinn.looneytriggs@gmail.com'
__version__ = '4.1'
__date__ = '2009-02-12'
__revised__ = '2013-05-13'
__status__ = 'Production'

#Nagios exit codes in English
UNKNOWN  = 3
CRITICAL = 2
WARNING  = 1
OK       = 0

try:
    import requests
except ImportError:
    print ('Python Requests module (http://docs.python-requests.org/) '
           'is required for this to work.')
    sys.exit(CRITICAL)

def extract_mtk_community():
    '''
    Get SNMP community string from /etc/mtk.conf
    '''
    mtk_conf_file = '/etc/mtk.conf'
    
    logger.debug('Obtaining serial number via {0}.'.format(mtk_conf_file))
    
    if os.path.isfile(mtk_conf_file):
        try:
            for line in open(mtk_conf_file, 'r'):
                token = line.split('=')
                
                if token[0] == 'community_string':
                    community_string = token[1].strip()
        except IOError:
            print 'Unable to open {0}, exiting!'.format(mtk_conf_file)
            sys.exit(UNKNOWN)
    else:
        print ('The {0} file does not exist, '
               'exiting!').format(mtk_conf_file)
        sys.exit(UNKNOWN)
        
    return community_string

def extract_service_tag():
    '''Extracts the serial number from the localhost using (in order of
    precedence) omreport, libsmbios, or dmidecode. This function takes 
    no arguments but expects omreport, libsmbios or dmidecode to exist 
    and also expects dmidecode to accept -s system-serial-number 
    (RHEL5 or later).
    
    '''
    
    dmidecode = which('dmidecode')
    libsmbios = False
    omreport  = which('omreport')
    service_tags = []
    
    #Test for the libsmbios module
    try:
        logger.debug('Attempting to load libsmbios_c.')
        import libsmbios_c
    except ImportError:
        logger.debug('Unable to load libsmbios_c continuing.')
        pass
    else:
        libsmbios = True
    
    if omreport:
        logger.debug('Obtaining serial number via OpenManage.')
        import re
        
        try:
            process = subprocess.Popen([omreport, "chassis", "info",
                                         "-fmt", "xml"],
                                 stdout=subprocess.PIPE, 
                                 stderr=subprocess.PIPE)
        except OSError:
            print 'Error: {0} exiting!'.format(sys.exc_info)
            sys.exit(WARNING)
            
        text = process.stdout.read()
        pattern = '''<ServiceTag>(\S+)</ServiceTag>'''
        regex = re.compile(pattern, re.X)
        service_tags = regex.findall(text)
        
    elif libsmbios:
        logger.debug('Obtaining serial number via libsmbios_c.')
        
        #You have to be root to extract the serial number via this method
        if os.geteuid() != 0: 
            print ('{0} must be run as root in order to access '
            'libsmbios, exiting!').format(sys.argv[0])
            sys.exit(WARNING)
        
        service_tags.append(libsmbios_c.system_info.get_service_tag())
        
    elif dmidecode: 
        logger.debug('Obtaining serial number via dmidecode.')
        #Gather the information from dmidecode
        
        sudo = which('sudo')
        
        if not sudo:
            print 'Sudo is not available, exiting!'
            sys.exit(WARNING)
        
        try:
            process = subprocess.Popen([sudo, dmidecode, "-s",
                                   "system-serial-number"], 
                                   stdout=subprocess.PIPE, 
                                   stderr=subprocess.PIPE)
        except OSError:
            print 'Error: {0} exiting!'.format(sys.exc_info)
            sys.exit(WARNING)
            
        service_tags.append(process.stdout.read().strip())
        
    else:
        print ('Omreport, libsmbios and dmidecode are not available in '
        '$PATH, exiting!')
        sys.exit(WARNING)
    
    return service_tags

#            
#            #Get enclosure type.
#            #   1: Internal
#            #   2: DellTM PowerVaultTM 200S (PowerVault 201S)
#            #   3: Dell PowerVault 210S (PowerVault 211S)
#            #   4: Dell PowerVault 220S (PowerVault 221S)
#            #   5: Dell PowerVault 660F
#            #   6: Dell PowerVault 224F
#            #   7: Dell PowerVault 660F/PowerVault 224F
#            #   8: Dell MD1000
#            #   9: Dell MD1120


def get_warranty_https(service_tag_list, timeout):
    '''
    Obtains the warranty information from Dell's website. This function 
    expects a list containing one or more serial numbers to be checked
    against Dell's database.
    '''
    
    url = 'https://api.dell.com/support/v2/assetinfo/warranty/tags.json'
    #Additional API keys, just in case: 
    #d676cf6e1e0ceb8fd14e8cb69acd812d
    #849e027f476027a394edd656eaef4842
    
    apikey = '1adecee8a60444738f280aad1cd87d0e'
    
    service_tags = ''
    
    if len(service_tag_list) == 1:
        service_tags = service_tag_list[0]
    else:
        for service_tag in service_tag_list:
            service_tags += service_tag + '|'
    
    #Because we can't have a trailing '|'
    service_tags = service_tags.rstrip('|')
    
    logger.debug('Requesting service tags: {0}'.format(service_tags))
    
    payload = {'svctags': service_tags, 'apikey': apikey}
    
    try:
        response = requests.get(url, params=payload, verify=False, 
                                timeout=timeout)
        
    except requests.exceptions.SSLError:
        print 'Unable to verify SSL certificate for url: {0}'.format(url)
        sys.exit(UNKNOWN)
    
    try:
        #Throw an exception for anything but 200 response code
        response.raise_for_status()
    except requests.exceptions.HTTPError:
        print 'Unable to contact url: {0}.format(url)'
        sys.exit(UNKNOWN)
    
    logger.debug('Requesting warranty information from Dell url: '
                 '{0}'.format(response.url))
    
    result = response.json()
    logger.debug('Raw output received: \n {0}'.format(result))
    
    #We test for any faults assserted by the api.
    check_faults(result)
    
    return result

def check_faults(response):
    '''
    This function checks the json content for faults that are rasied by Dell's
    API. Any faults results in immediate termination with status UNKNOWN.
    '''
    
    logger.debug('Testing for faults in json response.')
    fault = (response['GetAssetWarrantyResponse']['GetAssetWarrantyResult']
             ['Faults'])
    logger.debug('Raw fault return: {0}'.format(fault))
    
    if fault:
        logger.debug('Fault found.')
        
        code = fault['FaultException']['Code']
        message = fault['FaultException']['Message']
        
        print ('API fault code: "{0}" encountered, message: "{1}". '
               'Exiting!'.format(code, message))
        sys.exit(UNKNOWN)
    
    logger.debug('No faults found.')
    return None
    
def build_warranty_line(warranty, full_line, days, short_output):
    '''
    This function takes a warranty object and parses the salient information
    out. It then calculates the number of days remaining in the warranty 
    period, and builds a line for Nagios outputting.
    '''
    
    description = warranty['ServiceLevelDescription']
    end_date = warranty['EndDate']
    start_date = warranty['StartDate']
    provider = warranty['ServiceProvider']
    #machine_type = warranty['MachineDescription']
    
    logger.debug('Found: Start date: {0}, End Date: {1},Description: {2}, '
                 'Provider: {3}'.format(start_date, end_date, description, provider))
    
    #Because we need ot be able to calculate the time left as well as
    #better formatting.
    start_date = convert_date(start_date)
    end_date = convert_date(end_date)
    
    days_left = (end_date - datetime.date.today()).days
    
    #Because no one cares about egative numbers of days.
    if days_left < 0:
        days_left = 0
        
    logger.debug('Number of days left in warranty: '
                 '{0}'.format(days_left))
    
    if short_output:
        full_line = full_line + ', End: ' + str(end_date) \
        + ', Days left: ' + str(days_left)
    
    else: 
        full_line = full_line + ' Warranty: ' + description \
        + ', Provider: ' + provider + ', Start: ' + \
        str(start_date) + ', End: ' + str(end_date) + \
        ', Days left: ' + str(days_left)
    
    days.append(int(days_left))
    
    return full_line, days

def convert_date(date):
    '''
    This function converts the date as returned by the Dell API into a 
    datetime object. Dell's API format is as follows: 2010-07-01T01:00:00
    '''
    #Split on 'T' grab the date then split it out on '-'
    year, month, day = date.split('T')[0].split('-')
    
    return datetime.date(int(year), int(month), int(day))

def process_asset(asset, full_line, days, short_output):
    '''
    This function processes a json asset returned from Dell's API and
    builds a line appropriate for Nagios output, as well as the service
    tag for the line and the number of days remaining for each warranty
    as a list.
    '''
    
    logger.debug('Raw asset being processed: {0}'.format(asset))
        
    service_tag = asset['ServiceTag']
        
    for warranty in asset['Warranties']['Warranty']:
        full_line, days = build_warranty_line(warranty, full_line, 
                                              days, short_output)
    
    return service_tag, full_line, days

def parse_exit(result, short_output):
    
    critical = 0
    days = []
    warning = 0
    full_line = r'%s: Service Tag: %s'
    
    logger.debug('Beginning to parse results and construct exit line '
                 'and code.')
    
    assets = (result['GetAssetWarrantyResponse']['GetAssetWarrantyResult']
              ['Response']['DellAsset'])
    
    logger.debug('Assets obtained: {0}'.format(assets))
    
    #Check if there are multiple assets being provided
    if isinstance(assets, list):
        logger.debug('Multiple assets being processed.')
        
        for asset in assets:
            service_tag, full_line, days = process_asset(asset, full_line, 
                                                         days, short_output)
    
    #There is only one asset
    else:
        logger.debug('A single asset is being processed.')
        asset = assets
        service_tag, full_line, days = process_asset(asset, full_line, 
                                                     days, short_output)
    
    #Put the days remaining in ascending order
    days.sort()
    
    logger.debug('Days remaining on warranties: {0}'.format(days))
    
    if days[-1] < options.critical_days:
        state = 'CRITICAL'
        critical += 1
        
    elif days[-1] < options.warning_days:
        state = 'WARNING'
        warning += 1
        
    else:
        state = 'OK'
        
    print full_line % (state, service_tag),
    
    if critical:
        sys.exit(CRITICAL)
    elif warning:
        sys.exit(WARNING)
    else:
        sys.exit(OK)
    
    return None #Should never get here

def sigalarm_handler(signum, frame):
    '''
    Handler for an alarm situation.
    '''
    
    print ('{0} timed out after {1} seconds, '
           'signum:{2}, frame: {3}').format(sys.argv[0], options.timeout, 
                                            signum, frame)
    
    sys.exit(CRITICAL)
    return None

def which(program):
    '''This is the equivalent of the 'which' BASH built-in with a check to 
    make sure the program that is found is executable.
    '''
    
    def is_exe(file_path):
        '''Tests that a file exists and is executable.
        '''
        return os.path.exists(file_path) and os.access(file_path, os.X_OK)
    
    file_path = os.path.split(program)[0]
    
    if file_path:
        if is_exe(program):
            return program
    else:
        for path in os.environ["PATH"].split(os.pathsep):
            exe_file = os.path.join(path, program)
            if is_exe(exe_file):
                return exe_file

    return None

if __name__ == '__main__':
    import optparse
    import signal
    
    parser = optparse.OptionParser(description='''Nagios plug-in to pull the 
Dell service tag and check it against Dell's web site to see how many 
days remain. By default it issues a warning when there is less than 
thirty days remaining and critical when there is less than ten days 
remaining. These values can be adjusted using the command line, see --help.
''',
                                   prog="check_dell_warranty",
                                   version="%prog Version: {0}".format(__version__))
    parser.add_option('-a', dest='authProtocol', action='store',
                      help=('Set the default authentication protocol for '
                            'SNMPv3 (MD5 or SHA).'))
    parser.add_option('-A', dest='authPassword', 
                      help=('Set the SNMPv3 authentication protocol password.')
                      )
    parser.add_option('-C', '--community', action='store', 
                      dest='community', type='string',default='public', 
                      help=('SNMP Community String to use. '
                      '(Default: %default)'))
    parser.add_option('-c', '--critical', dest='critical_days', default=10,
                     help=('Number of days under which to return critical '
                     '(Default: %default).'), type='int', metavar='<ARG>')
    parser.add_option('-H', '--hostname', action='store', type='string', 
                      dest='hostname', 
                      help='Specify the host name of the SNMP agent')
    parser.add_option('-l', dest='secLevel', default='noAuthNoPriv',
                      action='store',
                      help=('Set the SNMPv3 security level, (noAuthNoPriv'
                      '|authNoPriv|authPriv) (Default: noAuthNoPriv)'))
    parser.add_option('--mtk', action='store_true', dest='mtk_installed', 
                      default=False,
                      help=('Get SNMP Community String from /etc/mtk.conf if '
                      'mtk-nagios plugin is installed. NOTE: This option '
                      'will make the mtk.conf community string take '
                      'precedence over anything entered at the '
                      'command line (Default: %default)'))
    parser.add_option('-p', '--port', dest='port', default=161,
                      help=('Set the SNMP port to be connected to '
                      '(Default:161).'), type='int')
    parser.add_option('-s', '--service_tag', dest='service_tag', 
                       help=('Dell Service Tag of system, to enter more than '
                      'one use multiple flags (Default: auto-detected)'),  
                      action='append', metavar='<ARG>')
    parser.add_option('-S', '--short', dest='short_output', 
                      action='store_true', default = False,
                      help=('Display short output: only the status, '
                      'service tag, end date and days left for each '
                      'warranty.'))
    parser.add_option('-t', '--timeout', dest='timeout', default=10,
                      help=('Set the timeout for the program to run '
                      '(Default: %default seconds)'), type='int', 
                      metavar='<ARG>')
    parser.add_option('-u', dest='secName', action='store',
                      help='Set the SNMPv3 security name (user name).')
    parser.add_option('-v', dest='version', default=3, action='store',
                      help=('Specify the SNMP version (1, 2, 3) Default: 3'),
                      type='int'
                      )
    parser.add_option('-V', dest='verbose', action='store_true', 
                      default=False, help =('Give verbose output (Default: '
                                            'Off)') 
                      )
    parser.add_option('-w', '--warning', dest='warning_days', default=30,
                      help=('Number of days under which to return a warning '
                      '(Default: %default)'), type='int', metavar='<ARG>' )
    parser.add_option('-x', dest='privProtocol', action='store',
                      help='Set the SNMPv3 privacy protocol (DES or AES).')
    parser.add_option('-X', dest='privPassword', action='store',
                      help='Set the SNMPv3 privacy pass phrase.')
    
    (options, args) = parser.parse_args()
    
    ##Configure logging
    logger = logging.getLogger("check_dell_warranty")
    handler = logging.StreamHandler()
    if options.verbose:
        sys.stderr.write('Switching on debug mode.\n')
        handler.setLevel(logging.DEBUG)
        logger.setLevel(logging.DEBUG)
        
    ##Set the logging format, time, log level name, and the message
    formatter = logging.Formatter('%(levelname)s - %(message)s')
    handler.setFormatter(formatter)
    
    logger.addHandler(handler)

    signal.signal(signal.SIGALRM, sigalarm_handler)
    signal.alarm(options.timeout)
    
    if options.service_tag:
        SERVICE_TAGS = options.service_tag
    elif options.hostname or options.mtk_installed:
        SERVICE_TAGS = extract_service_tag_snmp(options)
    else:
        SERVICE_TAGS = extract_service_tag()
    
    RESULT = get_warranty_https(SERVICE_TAGS, options.timeout)
    signal.alarm(0)
    
    parse_exit(RESULT, options.short_output)

