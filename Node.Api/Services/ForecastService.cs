using Grpc.Core;
using NodeGrpc.Api;
using NodeGrpcApi;

namespace NodeGrpc.Api.Services
{
    public class ForecastService : Forecast.ForecastBase
    {
        private static readonly string[] Summaries = new[]
       {
        "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
    };

        public override Task<WeatherForecastReply> GetForecast(GetForecastRequest request, ServerCallContext context)
        {
            var r = new WeatherForecastReply();
            r.Items.AddRange(GetForecasts());

            return Task.FromResult(r);
        }

        private static IEnumerable<WeatherForecastItem> GetForecasts()
        {
            return Enumerable.Range(1, 5).Select(index => new WeatherForecastItem
            {
                Date = DateTime.Now.AddDays(index).ToString(),
                TemperatureC = Random.Shared.Next(-20, 55),
                Summary = Summaries[Random.Shared.Next(Summaries.Length)]
            });
        }
    }
}