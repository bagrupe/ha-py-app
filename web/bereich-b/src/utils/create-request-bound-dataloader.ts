import DataLoader from 'dataloader'
import { type PayloadRequest } from 'payload'

export const createRequestBoundDataLoader =
  <K, V>(dataLoaderName: string, batchLoadFn: DataLoader.BatchLoadFn<K, V>) =>
  (req: PayloadRequest) => {
    const context = req.context ?? {}
    const existing = context[dataLoaderName] as DataLoader<K, V>
    if (existing) {
      return existing
    } else {
      const dataLoader = new DataLoader(batchLoadFn)
      context[dataLoaderName] = dataLoader
      return dataLoader
    }
  }
