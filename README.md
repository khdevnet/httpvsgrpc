# Load test scenarios
## Requirements
* Two API services hosted on Azure app services 
* Main Api send a request to Node Api by HTTP or GRPC
* Node API has data processing simulation what makes delay 100-120 ms
* Verify throughput of server-to-server communication using HTTP/GRPC protocol 
* Count requests where response time less then 1 sec 
* Test runs using NBomber from local computer.

## Environment
### Conditions

* Infrastructure hosted in West Europe
* Performance test runner machine located in West Europe: i7 11th Generation (2.8 GHz) / 16 GB RAM / Windows 11 OS
* Internet speed 100MB

### Azure infrastructure
```powershell
 az deployment sub create -l westeurope -f ./wnd-vnet/main.bicep --parameters './parameters.prod.json'
 az deployment sub create -l westeurope -f ./lnx-vnet/main.bicep --parameters './parameters.prod.json'
 ```

| Feature                               | URL                                                              | Kind                      | Azure service plan                             | Third party | Comment                 |
| ------------------------------------- | ---------------------------------------------------------------- | ------------------------- | ---------------------------------------------- | ----------- | ----------------------- |
| Main API                      | perf-main-api       | Api app service           | P1V3: 1 instance       |             |                         |  
| Node HTTP API                     | perf-http-node-api         | Api App                   | P1V3: 1 instance             |             |                        |
| Node GRPC API                     | perf-grpc-node-api         | Api App                   | P1V3: 1 instance             |             |                         |


### App service plan

| App service plan | Core | Ram     | Storage |
| ---------------- | ---- | ------- | ------- |
| Windows P1V3     | 2    | 8 GB    | 250 GB  |
| Linux P1V3       | 2    | 8 GB    | 250 GB  |

### App service windows/linux
| Key | Value |Comment |
| --- | ----  |--|
| HTTP version | 2 | wnd/lnx|
| Always on | ON |wnd/lnx|
| ARR Afinity | OFF |wnd/lnx|
| HTTPS Only | ON |wnd/lnx|
| HTTP proxy 2 | ON |lnx GRPC|

## Results
| Simulation      | Duration       |
| --------------- | -------------- |
| Ramp up traffic | 30 seconds     |
| Duration        | 2 minutes      |
| Time out        | 1 seconds      |

### Case 1: Run Asp.Net 7 API application on windows app services connected with vnet using HTTP contract
During run simulate 600 request per second 

![image](https://user-images.githubusercontent.com/14298158/218453254-c167fa3e-cc67-4859-acd9-eff2a60d4293.png)
[More reports in WndVnetHttpNet7](https://github.com/khdevnet/httpvsgrpc/tree/main/MainApi.PerformanceTest/Reports/WndVnetHttpNet7)

### Case 2: Run Asp.Net 7 API application on linux app services connected in vnet using HTTP contract
During run simulate 500 request per second 

![image](https://user-images.githubusercontent.com/14298158/218453781-0323ac22-3c92-4574-b4ec-bdefe831de7c.png)
[More reports in LnxVnetHttpNet7](https://github.com/khdevnet/httpvsgrpc/tree/main/MainApi.PerformanceTest/Reports/LnxVnetHttpNet7)
### Case 3: Run Asp.Net 7 API application on linux app services connected in vnet using GRPC contract
During run simulate 800 request per second 

![image](https://user-images.githubusercontent.com/14298158/218453959-aa222b2b-b5f4-4613-8f4a-a4801f946fba.png)
[More reports in LnxVnetGrpcNet7](https://github.com/khdevnet/httpvsgrpc/tree/main/MainApi.PerformanceTest/Reports/LnxVnetGrpcNet7)

## Summary
It was suprise for me but looks like windows app service plans on NET 7 could handle 600 RPS what is 100 RPS greater then on linux app service plan (Linux API throughput 500 RPS)
GRPC could be use only on linux app service plan and it was easier to run it with NET 7 but not on NET 6
GRPC could handle 800 RPS what is 36% greater then HTTP on linux



