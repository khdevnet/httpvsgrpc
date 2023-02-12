using Common;
using Main.Api.Clients;
using Microsoft.AspNetCore.Mvc;

namespace Main.Api.Controllers;

[ApiController]
[Route("[controller]")]
public class WeatherForecastController : ControllerBase
{
    private readonly IWeatherForecastHttpClient _weatherForecastHttpClient;
    private readonly WeatherForecastGrpcClient _weatherForecastGrpcClient;

    public WeatherForecastController(
        IWeatherForecastHttpClient weatherForecastHttpClient,
        WeatherForecastGrpcClient weatherForecastGrpcClient)
    {
        _weatherForecastHttpClient = weatherForecastHttpClient;
        _weatherForecastGrpcClient = weatherForecastGrpcClient;
    }

    [HttpGet("http", Name = "GetHttp")]
    public async Task<IEnumerable<WeatherForecast>> GetHttp()
    {
        return await _weatherForecastHttpClient.Get();
    }

    [HttpGet("grpc", Name = "GetGrpc")]
    public async Task<IEnumerable<WeatherForecast>> GetGrpc()
    {
        return await _weatherForecastGrpcClient.Get();
    }
}