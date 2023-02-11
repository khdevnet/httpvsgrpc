using Main.Api.Clients;
using RestEase.HttpClientFactory;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddApplicationInsightsTelemetry();

var configuration = builder.Configuration;
// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var weatherForecastApiBaseUri = configuration.GetValue<string>("NodeApi:BaseUrl", "https://localhost:32770");

builder.Services.AddRestEaseClient<IWeatherForecastHttpClient>(weatherForecastApiBaseUri);

builder.Services.AddSingleton<WeatherForecastGrpcClient>();

var app = builder.Build();

// Configure the HTTP request pipeline.
app.UseSwagger();
app.UseSwaggerUI();

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
