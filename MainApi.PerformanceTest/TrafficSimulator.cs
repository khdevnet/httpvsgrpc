using NBomber.Contracts;
using NBomber.Contracts.Stats;
using NBomber.CSharp;
using NBomber.Plugins.Http.CSharp;

namespace MainApi.PerformanceTest;

public class TrafficSimulator
{
    private const string MainBaseUrl = "https://perf-main-api-3xp4wzvswigfe.azurewebsites.net";
    private LoadSimulation LoadSimulation = Simulation.InjectPerSec(
            rate: 10,
            during: TimeSpan.FromSeconds(120));
    // 600 RPS
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
        var httpFactory = HttpClientFactory.Create();

        var step = Step.Create(
                        scenarioName,
                        httpFactory,
                        context => Http.Send(Http.CreateRequest("GET", url), context),
                        timeout: TimeSpan.FromSeconds(1));

        var scenario = ScenarioBuilder
              .CreateScenario("WeatherForecast", step)
              .WithLoadSimulations(loadSimulation);


        NBomberRunner
            .RegisterScenarios(scenario)
            .WithReportFormats(ReportFormat.Html, ReportFormat.Md)
            .Run();
    }
}