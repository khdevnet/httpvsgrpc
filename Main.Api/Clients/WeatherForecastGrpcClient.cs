using Common;
using Grpc.Net.Client;

namespace Main.Api.Clients;

public class WeatherForecastGrpcClient : IDisposable
{
    private GrpcChannel _channel;
    private WeatherForecastService.WeatherForecastServiceClient _client;

    public WeatherForecastGrpcClient(IConfiguration configuration)
    {
        var weatherForecastApiBaseUri = configuration.GetValue<string>("NodeApi:BaseUrl", "https://localhost:7108");

        _channel = GrpcChannel.ForAddress(weatherForecastApiBaseUri);
        _client = new WeatherForecastService.WeatherForecastServiceClient(_channel);
    }

    public async Task<IEnumerable<WeatherForecast>> Get()
    {
        var reply = await _client.GetForecastAsync(new GetForecastRequest { });
        var response = reply.Items.Select(x => new WeatherForecast { Date = DateTime.Parse(x.Date), Summary = x.Summary, TemperatureC = x.TemperatureC });
        return response;
    }

    public void Dispose()
    {
        _channel?.Dispose();
    }
}
