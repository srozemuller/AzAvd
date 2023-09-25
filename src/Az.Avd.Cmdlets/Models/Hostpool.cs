using System.Text.Json;

namespace Az.Avd.Cmdlets.Models;

public sealed record GraphValueResponse<T>
{
    public IEnumerable<T>? Value { get; init; }
}

public sealed record Hostpool
{
    public string Id { get; init; } = string.Empty;
    public string Name { get; init; } = string.Empty;
    public string Description { get; init; } = string.Empty;
}

public static class CustomJsonOptions
{
    public static JsonSerializerOptions Default()
    {
        return new JsonSerializerOptions
        {
            PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
            PropertyNameCaseInsensitive = true,
        };
    }
}
