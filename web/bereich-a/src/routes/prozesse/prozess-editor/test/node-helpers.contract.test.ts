import {describe, expect, it} from 'vitest';
import {type SchrittNode} from '../lib/flow/flow.types.ts';
import {getDeleteAction} from '../lib/node-helpers.ts';
import {makeEdge, makeNode} from './support/make-flow.ts';

const ghost = (id: string): SchrittNode =>
  makeNode(id, {
    schritt: {
      __typename: 'GhostSchritt',
      titel: 'Platzhalter',
      slots: [],
    } as unknown as Partial<SchrittNode['data']['schritt']>,
  });

describe('getDeleteAction', () => {
  it('bulk-deletes when more than one node is selected', () => {
    expect(
      getDeleteAction({nodes: [makeNode('a'), makeNode('b')], edges: []}),
    ).toBe('delete-many');
  });

  it('bulk-deletes a multi-node selection even when connections are incident', () => {
    expect(
      getDeleteAction({
        nodes: [makeNode('a'), makeNode('b'), makeNode('c')],
        edges: [makeEdge('e1', 'a', 'b')],
      }),
    ).toBe('delete-many');
  });

  it('detaches a single connected normal node', () => {
    expect(
      getDeleteAction({
        nodes: [makeNode('a')],
        edges: [makeEdge('e1', 'a', 'b')],
      }),
    ).toBe('detach-node');
  });

  it('deletes a single isolated normal node', () => {
    expect(getDeleteAction({nodes: [makeNode('a')], edges: []})).toBe(
      'delete-node',
    );
  });

  it('deletes a single ghost node (with or without edges)', () => {
    expect(
      getDeleteAction({
        nodes: [ghost('GHOST-1')],
        edges: [makeEdge('e1', 'GHOST-1', 'b')],
      }),
    ).toBe('delete-ghost-node');
    expect(getDeleteAction({nodes: [ghost('GHOST-1')], edges: []})).toBe(
      'delete-ghost-node',
    );
  });

  it('deletes edges when no node is selected', () => {
    expect(
      getDeleteAction({nodes: [], edges: [makeEdge('e1', 'a', 'b')]}),
    ).toBe('delete-edge');
  });
});
