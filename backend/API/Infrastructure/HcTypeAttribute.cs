namespace API.Infrastructure;

/// <summary>
/// Hot Chocolate allows declaring Interfaces and Unions through Attributes:
///  - https://chillicream.com/docs/hotchocolate/defining-a-schema/interfaces
///  - https://chillicream.com/docs/hotchocolate/defining-a-schema/unions
/// However the implementing classes still have to be added to the schema code first.
///
/// This Attribute may be added to a class that implements an interface type or is part of a union type to be added
///  to the schema without additional efforts.
/// </summary>
[AttributeUsage(AttributeTargets.Class)]
public class HcTypeAttribute : Attribute { }
