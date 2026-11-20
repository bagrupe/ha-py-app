using System.Text.Json;

namespace API.Features.Prozess.Queries;

/// <summary>Erweitert den Typ PlainSlotValue um Abfragen zu Slot-Werten.</summary>
[ExtendObjectType<PlainSlotValue>]
public class SlotValueQueries {
    /// <summary>Ermittelt die Anzahl der Elemente im Slot-Wert, falls dieser ein JSON-Array ist.</summary>
    /// <param name="plainSlotValue">Der zu untersuchende Slot-Wert.</param>
    /// <returns>Die Anzahl der Elemente im Array oder 0, falls kein Array vorliegt.</returns>
    [GraphQLDescription("Gibt die Anzahl der Elemente im Slot-Wert zurück, falls dieser ein Array ist.")]
    public int GetSlotValueCount(
        [Parent] PlainSlotValue plainSlotValue) {

        if (plainSlotValue is not { Value.ValueKind: JsonValueKind.Array }) {
            return 0;
        }

        var jsonArray = plainSlotValue.Value.EnumerateArray();
        return jsonArray.Count();
    }
}
