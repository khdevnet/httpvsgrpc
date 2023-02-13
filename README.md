# Azure environment configuration
```
 az deployment sub create -l westeurope -f main.bicep --parameters './parameters.dev.json'
 ```

# Load test scenarios
## Requirements
Two Api services what hosted on Azure app services communicate by HTTP   
Verify throughput of server to server communication using HTTP client Main Api send request to Node Api 
Response time shoud be less then 1 sec
Test runs using NBomber from local computer.

## Environment

### Conditions

* Infrastructure hosted in West Europe
* Performance test runner machine located in West Europe: i7 11th Generation (2.8 GHz) / 16 GB RAM / Windows 11 OS, internet speed 100MB

### Azure infrastructure
| Feature                               | URL                                                              | Kind                      | Azure service plan                             | Third party | Comment                 |
| ------------------------------------- | ---------------------------------------------------------------- | ------------------------- | ---------------------------------------------- | ----------- | ----------------------- |
| Main API                      | perf-main-api       | Api app service           | P1V3: 1 instance       |             |                         |  
| Node API                     | perf-http-node-api         | Api App                   | P1V3: 1 instance             |             |                         |


### App service plan

| App service plan | Core | Ram     | Storage | Outbound connections |
| ---------------- | ---- | ------- | ------- | -------------------- |
| Windows P1V3     | 2    | 8 GB    | 250 GB   |                     |
| Linux P1V3       | 2    | 8 GB    | 250 GB   |                     |

### App service windows/linux
| Key | Value |
| --- | ----  |
| HTTP version | 2 |
| Always on | ON |
| ARR Afinity | OFF |
| HTTPS Only | ON |

### App service linux grpc
| Key | Value |
| --- | ----  |
| HTTP version | 2 |
| Always on | ON |
| ARR Afinity | OFF |
| HTTPS Only | ON |
| HTTP proxy 2 | ON |

## Scenario
| Simulation      | Duration       |
| --------------- | -------------- |
| Ramp up traffic | 30 seconds     |
| Duration        | 2 minutes      |
| Time out        | 1 seconds      |
| RPS             | 500 per second |


## Results
### Case 1:
Run Asp.Net 7 API application on windows app services connected with vnet using HTTP contract

### Case 2:
Run services on linux app services connected with vnet using HTTP contract

### Case 3:
Run services on linux app services connected with vnet using GRPC contract


