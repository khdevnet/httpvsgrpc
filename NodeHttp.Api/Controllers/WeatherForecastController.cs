using Common;
using Microsoft.AspNetCore.Mvc;

namespace Node.Api.Controllers;

[ApiController]
[Route("[controller]")]
public class WeatherForecastController : ControllerBase
{
    private readonly ForecastDataService _forecastDataService;

    public WeatherForecastController(ForecastDataService forecastDataService)
        => _forecastDataService = forecastDataService;

    [HttpGet(Name = "GetWeatherForecast")]
    public async Task<IEnumerable<WeatherForecast>> Get() => await _forecastDataService.Get();
}