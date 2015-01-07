#!/usr/bin/env python

import SoftLayer.API
from pprint import pprint as pp

apiUsername = 'jmatthews'
apiKey = '956d7fa0ef3a49e24d401e5b05f2aa968ed577f65db38530f1a7c24f4ab2c650'

client = SoftLayer.Client(
    username=apiUsername,
    api_key=apiKey,
)

start_date = '01/01/2010'
end_date = '01/01/2015'

# Virtual Guest ID
server_id = 176354

# Retrieve all SoftLayer_Monitoring_Agent objects associated with this server
monitoring_agents = client['Virtual_Guest'].getMonitoringAgents(id=server_id)

# Store the Cpu, Disk, and Memory Monitoring Agent as cpu_disk_mem_agent
for agent in monitoring_agents:
    if agent['name'] == 'Cpu, Disk, and Memory Monitoring Agent':
        cpu_disk_mem_agent = agent

# Retrieve a list of SoftLayer_Monitoring_Agent_Configuration_Value objects
mask = 'mask.definition.monitoringDataFlag'
configuration_values = client['Monitoring_Agent'].getConfigurationValues(
    mask=mask, id=cpu_disk_mem_agent['id'])

# Bulid a list of SoftLayer_Container_Metric_Data_Type objects
metric_data_types = []
for configuration_value in configuration_values:
    # We only need configuration_values that have a 'value' and
    # 'monitoringDataFlag' of True
    if configuration_value['value'] is False:
        continue

    if configuration_value['definition']['monitoringDataFlag'] is not True:
        continue

    types = client['Monitoring_Agent_Configuration_Value'].getMetricDataType(
        id=configuration_value['id'])
    metric_data_types.append(types)

# Retrieve & display the graph data points
#print (metric_data_types)
data = client['Monitoring_Agent'].getGraphData(
    metric_data_types, start_date, end_date, id=cpu_disk_mem_agent['id'])
pp(data)
