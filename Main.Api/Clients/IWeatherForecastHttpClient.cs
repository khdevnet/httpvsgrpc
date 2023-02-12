using Common;
using RestEase;

namespace Main.Api.Clients;

public interface IWeatherForecastHttpClient
{
    [Get("WeatherForecast")]
    Task<IEnumerable<WeatherForecast>> Get(); 
}
