using Common;
using Grpc.Net.Client;
using NodeGrpcApi;
using static NodeGrpcApi.Forecast;

namespace Main.Api.Clients;

public class WeatherForecastGrpcClient : IDisposable
{
    private GrpcChannel _channel;
    private ForecastClient _client;

    public WeatherForecastGrpcClient(IConfiguration configuration)
    {
        var weatherForecastApiBaseUri = configuration.GetValue<string>("NodeGrpcApi:BaseUrl", "https://localhost:7174");

        _channel = GrpcChannel.ForAddress(weatherForecastApiBaseUri);
        _client = new ForecastClient(_channel);
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
