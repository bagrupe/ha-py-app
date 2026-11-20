using HotChocolate.Language;

namespace API.Features.Prozess.Queries;

internal static class SlotNameFilter {
    /// <summary>Liefert die Slot-Namen oder <c>null</c>, wenn der Filter etwas anderes enthält (dann alles laden).</summary>
    internal static IReadOnlyList<string>? TryExtractNames(IValueNode? where) {
        var names = new List<string>();
        return TryCollect(where, names) && names.Count > 0 ? names.Distinct().ToList() : null;
    }

    private static bool TryCollect(IValueNode? node, List<string> names) {
        if (node is not ObjectValueNode { Fields.Count: 1 } obj) {
            return false;
        }

        var field = obj.Fields[0];
        switch (field.Name.Value) {
            case "slotName":
                return TryCollectOperation(field.Value, names);
            case "or" when field.Value is ListValueNode list:
                return list.Items.Count > 0 && list.Items.All(item => TryCollect(item, names));
            default:
                return false;
        }
    }

    private static bool TryCollectOperation(IValueNode node, List<string> names) {
        if (node is not ObjectValueNode { Fields.Count: 1 } operation) {
            return false;
        }

        var field = operation.Fields[0];
        switch (field.Name.Value) {
            case "eq" when field.Value is StringValueNode name:
                names.Add(name.Value);
                return true;
            case "in" when field.Value is ListValueNode list && list.Items.All(i => i is StringValueNode):
                names.AddRange(list.Items.Cast<StringValueNode>().Select(i => i.Value));
                return true;
            default:
                return false;
        }
    }
}
