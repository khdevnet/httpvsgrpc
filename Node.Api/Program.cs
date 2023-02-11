using NodeGrpc.Api.Services;

var builder = WebApplication.CreateBuilder(args);

//builder.Services.AddApplicationInsightsTelemetry();

// Add services to the container.
builder.Services.AddGrpc();
builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
app.UseSwagger();
app.UseSwaggerUI();

app.UseHttpsRedirection();

app.UseAuthorization();
app.MapGrpcService<ForecastService>();
app.MapControllers();

app.Run();
