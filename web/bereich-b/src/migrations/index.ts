import * as migration_20260308_132136_migration from './20260308_132136_migration';
import * as migration_20260310_140608_migration from './20260310_140608_migration';
import * as migration_20260310_150801_migration from './20260310_150801_migration';
import * as migration_20260602_101500_slate_lexical_catchup from './20260602_101500_slate_lexical_catchup';
import * as migration_20261014_120000_remove_image_url_links from './20261014_120000_remove_image_url_links';
import * as migration_20261015_090000_resolve_encoded_relative_links from './20261015_090000_resolve_encoded_relative_links';
import * as migration_20261119_090000_reimport_ikiss_veranstaltungen from './20261119_090000_reimport_ikiss_veranstaltungen';

export const migrations = [
  {
    up: migration_20260308_132136_migration.up,
    down: migration_20260308_132136_migration.down,
    name: '20260308_132136_migration',
  },
  {
    up: migration_20260310_140608_migration.up,
    down: migration_20260310_140608_migration.down,
    name: '20260310_140608_migration',
  },
  {
    up: migration_20260310_150801_migration.up,
    down: migration_20260310_150801_migration.down,
    name: '20260310_150801_migration'
  },
  {
    up: migration_20260602_101500_slate_lexical_catchup.up,
    down: migration_20260602_101500_slate_lexical_catchup.down,
    name: '20260602_101500_slate_lexical_catchup'
  },
  {
    up: migration_20261014_120000_remove_image_url_links.up,
    down: migration_20261014_120000_remove_image_url_links.down,
    name: '20261014_120000_remove_image_url_links'
  },
  {
    up: migration_20261015_090000_resolve_encoded_relative_links.up,
    down: migration_20261015_090000_resolve_encoded_relative_links.down,
    name: '20261015_090000_resolve_encoded_relative_links'
  },
  {
    up: migration_20261119_090000_reimport_ikiss_veranstaltungen.up,
    down: migration_20261119_090000_reimport_ikiss_veranstaltungen.down,
    name: '20261119_090000_reimport_ikiss_veranstaltungen'
  },
];
