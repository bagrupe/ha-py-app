/** @vitest-environment jsdom */
import {cleanup, render} from '@testing-library/react';
import {Position} from '@xyflow/react';
import {afterEach, describe, expect, it} from 'vitest';
import {
  KommunalappBezierProzessEdge,
  type KommunalappProzessEdgeProps,
} from '../components/kommunalapp-prozess-edge.tsx';
import {useProzessEditorStore} from '../lib/store';
import {makeNode} from './support/make-flow.ts';

const edgeProps: KommunalappProzessEdgeProps = {
  id: 'a-to-b',
  source: 'a',
  target: 'b',
  sourceX: 0,
  sourceY: 0,
  targetX: 100,
  targetY: 0,
  sourcePosition: Position.Right,
  targetPosition: Position.Left,
  data: {automatisierung: false},
};

const renderEdge = (selectedNodeId: 'a' | 'b') => {
  useProzessEditorStore.setState({
    nodes: [
      makeNode('a', {selected: selectedNodeId === 'a'}),
      makeNode('b', {selected: selectedNodeId === 'b'}),
    ],
  });

  const {container} = render(
    <svg>
      <KommunalappBezierProzessEdge {...edgeProps} />
    </svg>,
  );
  const path = container.querySelector<SVGPathElement>(
    '.react-flow__edge-path',
  );
  expect(path).not.toBeNull();
  return path!;
};

afterEach(() => {
  cleanup();
  useProzessEditorStore.setState({nodes: []});
});

describe('Prozess-Editor edge highlighting', () => {
  it.each([
    ['source', 'a'],
    ['target', 'b'],
  ] as const)(
    'highlights an edge when only its %s node is selected',
    (_, selectedNodeId) => {
      const path = renderEdge(selectedNodeId);

      expect(path.style.stroke).toBe('rgb(var(--color-primary))');
      expect(path.style.strokeWidth).toBe('2');
    },
  );
});
