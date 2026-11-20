using API.Features.Ehrenamtsbank;

namespace UnitTests;

public class EhrenamtsbankKategorieTreeTest {
    private static EhrenamtsbankKategorie Kategorie(Guid id, bool active, Guid? parentId = null) =>
        new() { Id = id, Name = id.ToString(), Active = active, ParentId = parentId };

    private static IReadOnlySet<Guid> FilteredIds(params EhrenamtsbankKategorie[] all) =>
        KategorieTree.FilterEffectivelyActive(all).Select(k => k.Id).ToHashSet();

    [Fact]
    public void ActiveRootIsDelivered() {
        var root = Kategorie(Guid.NewGuid(), active: true);

        Assert.Equal(new HashSet<Guid> { root.Id }, FilteredIds(root));
    }

    [Fact]
    public void InactiveRootIsExcluded() {
        var root = Kategorie(Guid.NewGuid(), active: false);

        Assert.Empty(KategorieTree.FilterEffectivelyActive([root]));
    }

    [Fact]
    public void ActiveChildOfActiveRootIsDelivered() {
        var root = Kategorie(Guid.NewGuid(), active: true);
        var child = Kategorie(Guid.NewGuid(), active: true, parentId: root.Id);

        Assert.Equal(new HashSet<Guid> { root.Id, child.Id }, FilteredIds(root, child));
    }

    [Fact]
    public void ActiveChildOfInactiveRootIsExcluded() {
        var root = Kategorie(Guid.NewGuid(), active: false);
        var child = Kategorie(Guid.NewGuid(), active: true, parentId: root.Id);

        Assert.Empty(KategorieTree.FilterEffectivelyActive([root, child]));
    }

    [Fact]
    public void InactiveLeafIsExcludedButActiveSiblingsRemain() {
        var root = Kategorie(Guid.NewGuid(), active: true);
        var activeLeaf = Kategorie(Guid.NewGuid(), active: true, parentId: root.Id);
        var inactiveLeaf = Kategorie(Guid.NewGuid(), active: false, parentId: root.Id);

        Assert.Equal(
            new HashSet<Guid> { root.Id, activeLeaf.Id },
            FilteredIds(root, activeLeaf, inactiveLeaf));
    }

    [Fact]
    public void InactiveMidLevelPrunesEntireSubtreeBelow() {
        var a = Kategorie(Guid.NewGuid(), active: true);
        var b = Kategorie(Guid.NewGuid(), active: false, parentId: a.Id);
        var c = Kategorie(Guid.NewGuid(), active: true, parentId: b.Id);

        Assert.Equal(new HashSet<Guid> { a.Id }, FilteredIds(a, b, c));
    }

    [Fact]
    public void OrphanParentReferenceIsTreatedAsRoot() {
        var orphan = Kategorie(Guid.NewGuid(), active: true, parentId: Guid.NewGuid());

        Assert.Equal(new HashSet<Guid> { orphan.Id }, FilteredIds(orphan));
    }

    [Fact]
    public void CyclesAreExcludedAndDoNotHang() {
        var a = Kategorie(Guid.NewGuid(), active: true);
        var b = Kategorie(Guid.NewGuid(), active: true, parentId: a.Id);
        a.ParentId = b.Id;

        Assert.Empty(KategorieTree.FilterEffectivelyActive([a, b]));
    }
}
