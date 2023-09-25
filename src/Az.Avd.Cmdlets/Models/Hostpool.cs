using System.Text.Json.Serialization;

namespace Az.Avd.Cmdlets.Models;

public sealed record Hostpool
{
    [JsonPropertyName("id")]
    public string Id { get; init; } = string.Empty;

    [JsonPropertyName("name ")]
    public string Name { get; init; } = string.Empty;

    [JsonPropertyName("description")]
    public string Description { get; init; } = string.Empty;
}
