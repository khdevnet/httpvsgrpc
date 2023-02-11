# Azure environment configuration
```
 az deployment sub create -l westeurope -f main.bicep --parameters './parameters.dev.json'
 ```

# Load test scenarios
## Requirements
Two Api services what hosted on Azure app services communicate by http   
Verify throughput of server to server communication using HTTP client Main Api send request to Node Api 
Entry url for main 
GET https://perf-main-api-3xp4wzvswigfe.azurewebsites.net/WeatherForecast/http
Response time shoud be less then 1 sec
Test runs using NBomber from local computer.


## NBomber Scenario
| Simulation      | Duration     |
| --------------- | ------------ |
| Ramp up traffic | 30 seconds    |
| Duration        | 2 minutes    |
| Time out        | 1 seconds   |
| RPS             | 500 per second |

## Environment

### Conditions

* Infrastructure hosted in West Europe
* Performance test runner machine located in West Europe: i7 11th Generation (2.8 GHz) / 16 GB RAM / Windows 11 OS, internet speed 100MB

### Azure infrastructure
| Feature                               | URL                                                              | Kind                      | Azure service plan                             | Third party | Comment                 |
| ------------------------------------- | ---------------------------------------------------------------- | ------------------------- | ---------------------------------------------- | ----------- | ----------------------- |
| Main API                      | https://perf-main-api-3xp4wzvswigfe.azurewebsites.net       | Api app service           | P1V3: 1 instance       |             |                         |  
| Node API                     | https://perf-node-api-3xp4wzvswigfe.azurewebsites.net         | Api App                   | P1V3: 1 instance             |             |                         |


### App service plan

| App service plan | Core | Ram     | Storage | Outbound connections |
| ---------------- | ---- | ------- | ------- | -------------------- |
| P1V3             | 2    | 8 GB | 250 GB   |                     |


## Results

