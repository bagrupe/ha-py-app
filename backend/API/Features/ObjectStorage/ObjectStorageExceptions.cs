namespace API.Features.ObjectStorage;

/// <summary>Thrown when a requested object does not exist.</summary>
public class ObjectNotFoundException(string key) : Exception($"Object '{key}' does not exist.");

/// <summary>Thrown by every storage operation when the <c>ObjectStorage</c> section is not configured.</summary>
public class ObjectStorageDisabledException() : Exception("Object storage is not configured.");
