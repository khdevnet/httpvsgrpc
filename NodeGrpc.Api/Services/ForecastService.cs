using Common;
using Grpc.Core;
using NodeGrpcApi;

namespace Node.Api.Services;

public class ForecastService : Forecast.ForecastBase
{
    private readonly ForecastDataService _forecastDataService;

    public ForecastService(ForecastDataService forecastDataService)
        => _forecastDataService = forecastDataService;

    public override async Task<WeatherForecastReply> GetForecast(GetForecastRequest request, ServerCallContext context)
    {
        var forecasts = await GetForecasts();
        var r = new WeatherForecastReply();
        r.Items.AddRange(forecasts);
        return r;
    }

    private async Task<IEnumerable<WeatherForecastItem>> GetForecasts()
    {
        var data = await _forecastDataService.Get();
        return data.Select(f => new WeatherForecastItem
        {
            Date = f.Date.ToString(),
            TemperatureC = f.TemperatureC,
            Summary = f.Summary,
            TemperatureF = f.TemperatureF
        });
    }
}