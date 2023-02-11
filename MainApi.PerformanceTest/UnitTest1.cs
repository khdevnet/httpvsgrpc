using NBomber.Contracts;
using NBomber.CSharp;
using NBomber.Http.CSharp;

namespace MainApi.PerformanceTest
{
    public class UnitTest1
    {
        private const string MainBaseUrl = "https://perf-main-api-3xp4wzvswigfe.azurewebsites.net";
        private LoadSimulation LoadSimulation = Simulation.Inject(
                rate: 50,
                interval: TimeSpan.FromSeconds(1),
                during: TimeSpan.FromSeconds(120));

        [Fact]
        public void GetWeatherForecastHttp()
        {
            RunSimulation(
                        scenarioName: "GetWeatherForecastHttp",
                        url: $"{MainBaseUrl}/WeatherForecast/http",
                        loadSimulation: LoadSimulation);
        }

        [Fact]
        public void GetWeatherForecastGrpc()
        {
            RunSimulation(
              scenarioName: "GetWeatherForecastGrpc",
              url: $"{MainBaseUrl}/WeatherForecast/grpc",
              loadSimulation: LoadSimulation);
        }

        private void RunSimulation(string scenarioName, string url, LoadSimulation loadSimulation)
        {
            var httpClient = new HttpClient();

            var scenario = Scenario.Create(scenarioName, async context =>
            {
                var step1 = await Step.Run("GetForecast", context, async () =>
                {
                    var request =
                        Http.CreateRequest("GET", url);

                    var response = await Http.Send(httpClient, request);

                    return response;
                });

                return Response.Ok();
            })
            .WithoutWarmUp()
            .WithLoadSimulations(loadSimulation);

            NBomberRunner
                .RegisterScenarios(scenario)
                .Run();
        }
    }
}