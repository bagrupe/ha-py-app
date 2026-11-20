using HotChocolate.Authorization;
using HotChocolate.Data.Filters;
using HotChocolate.Data.Sorting;
using Microsoft.EntityFrameworkCore;

namespace API.Features.Ehrenamtsbank.Queries;

[QueryType]
public class KategorieQueries {
    /// <summary>
    /// Liefert alle effektiv aktiven Ehrenamtsbank-Kategorien flach aus. Eine Kategorie ist nur
    /// dann enthalten, wenn sie selbst und alle ihre Eltern bis zur Wurzel aktiv sind; der Baum
    /// wird clientseitig über <see cref="EhrenamtsbankKategorie.ParentId"/> wieder zusammengesetzt.
    /// </summary>
    [AllowAnonymous]
    [HotChocolate.Data.UseFiltering(typeof(EhrenamtsbankKategorieFilterInputType))]
    [HotChocolate.Data.UseSorting(typeof(EhrenamtsbankKategorieSortInputType))]
    public async Task<IEnumerable<EhrenamtsbankKategorie>> EhrenamtsbankKategorien(
        DomainContext context, CancellationToken ct) {
        var all = await context.EhrenamtsbankKategorien.ToListAsync(ct);

        foreach (var kategorie in all) {
            kategorie.RequiresEffectiveClearance =
                KategorieTree.RequiresEffectiveClearance(kategorie.Id, all);
        }

        return KategorieTree.FilterEffectivelyActive(all)
            .OrderBy(kategorie => kategorie.Sort)
            .ThenBy(kategorie => kategorie.Id);
    }
}

public sealed class EhrenamtsbankKategorieFilterInputType : FilterInputType<EhrenamtsbankKategorie> {
    protected override void Configure(IFilterInputTypeDescriptor<EhrenamtsbankKategorie> descriptor) {
        descriptor.BindFieldsExplicitly();
        descriptor.Field(kategorie => kategorie.RequiresEffectiveClearance).Name("requiresClearance");
        descriptor.Field(kategorie => kategorie.ParentId);
    }
}

public sealed class EhrenamtsbankKategorieSortInputType : SortInputType<EhrenamtsbankKategorie> {
    protected override void Configure(ISortInputTypeDescriptor<EhrenamtsbankKategorie> descriptor) {
        descriptor.BindFieldsExplicitly();
        descriptor.Field(kategorie => kategorie.Name);
    }
}
