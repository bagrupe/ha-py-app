using System.Text.Json;
using HotChocolate.Configuration;
using HotChocolate.Language;
using HotChocolate.Types.Descriptors;
using HotChocolate.Types.Descriptors.Definitions;

namespace API.Infrastructure;

/// <summary>Behebt das Problem von JSON-Feldern in zusammengefügten GraphQL-Schemas durch Anpassung der Middleware.</summary>
public class FixStitchedJsonTypeInterceptor : TypeInterceptor {
    /// <summary>Fügt vor der Fertigstellung eines Typs Middleware hinzu, die JSON-Felder korrekt serialisiert.</summary>
    /// <param name="completionContext">Kontext der Typvervollständigung.</param>
    /// <param name="definition">Definition des zu vervollständigenden Typs.</param>
    public override void OnBeforeCompleteType(ITypeCompletionContext completionContext, DefinitionBase definition) {
        if (definition is not ObjectTypeDefinition { HasDirectives: true } objectTypeDefinition ||
            !objectTypeDefinition.Directives.Any(x => x.Type is NameDirectiveReference { Name: "source" })) {
            // Object is not from remote schema
            return;
        }

        foreach (var objectFieldDefinition in objectTypeDefinition.Fields) {
            if (objectFieldDefinition.Type is SyntaxTypeReference { Name: "JSON" }) {
                objectFieldDefinition.MiddlewareDefinitions.Add(new FieldMiddlewareDefinition(
                    _ => context => {
                        var parentDictionary = context.Parent<Dictionary<string, object>>();
                        parentDictionary.TryGetValue(context.Selection.ResponseName, out var value);
                        var unpacked = value is not null ? UnpackNodes(value) : value;
                        context.Result = JsonSerializer.SerializeToElement(unpacked);
                        return ValueTask.CompletedTask;
                    },
                    isRepeatable: true,
                    key: nameof(FixStitchedJsonTypeInterceptor)
                ));
            }
        }
    }

    /// <summary>Entpackt rekursiv Knoten wie StringValueNode in ihre primitiven Werte.</summary>
    /// <param name="root">Der Wurzelknoten, der entpackt werden soll.</param>
    /// <returns>Das entpackte Objekt mit primitiven Werten.</returns>
    private static object UnpackNodes(object root) {
        var queue = new Queue<object>();
        var result = ProcessNode(root);

        while (queue.Count > 0) {
            var curr = queue.Dequeue();
            switch (curr) {
                case Dictionary<string, object> dict: {
                        foreach (var (key, value) in dict) {
                            dict[key] = ProcessNode(value);
                        }

                        break;
                    }
                case List<object> list: {
                        for (var i = 0; i < list.Count; i++) {
                            var value = list[i];
                            list[i] = ProcessNode(value);
                        }

                        break;
                    }
            }
        }

        return result;

        object ProcessNode(object node) {
            switch (node) {
                case Dictionary<string, object> dict: {
                        var clone = new Dictionary<string, object>(dict);
                        queue.Enqueue(clone);
                        return clone;
                    }
                case List<object> list: {
                        var clone = list.ToList();
                        queue.Enqueue(clone);
                        return clone;
                    }
                default:
                    return node switch {
                        StringValueNode stringValueNode => stringValueNode.Value,
                        BooleanValueNode booleanValueNode => booleanValueNode.Value,
                        IntValueNode intValueNode => intValueNode.ToInt64(),
                        FloatValueNode floatValueNode => floatValueNode.ToDouble(),
                        _ => node,
                    };
            }
        }
    }
}
