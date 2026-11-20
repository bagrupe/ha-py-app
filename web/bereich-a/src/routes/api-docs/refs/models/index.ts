import commonModels from './common.json';
import kommuneModel from './kommune.json';
import newsArtikelModel from './news-artikel.json';
import poiModel from './pois.json';
import veranstaltungskalenderModel from './veranstaltungskalender.json';

export const model = {
  definitions: {
    ...commonModels,
    ...kommuneModel,
    ...newsArtikelModel,
    ...poiModel,
    ...veranstaltungskalenderModel,
  },
};
