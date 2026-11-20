import {
  getSmartEdge,
  pathfindingJumpPointNoDiagonal,
  type SmartEdgeOptions,
  SmartStepEdge,
  svgDrawStraightLinePath,
} from '@tisoap/react-flow-smart-edge';
import {
  type EdgeProps,
  useNodes,
  type Edge,
  BaseEdge,
  BezierEdge,
  getBezierPath,
  EdgeLabelRenderer,
} from '@xyflow/react';
import {type CSSProperties, type FC, useMemo, memo} from 'react';
import {useProzessEditorStore} from '../lib/store';

/**
 * Eigenschaften für eine Prozesskante in der Kommunal-App.
 */
export type KommunalappProzessEdgeProps = EdgeProps<Edge>;

const selectedEdgeStyle: CSSProperties = {
  stroke: 'rgb(var(--color-primary))',
  strokeWidth: 2,
};

const edgeLabelStyling = {
  labelShowBg: true,
  labelBgBorderRadius: 6,
  labelBgPadding: [8, 4] as [number, number],
  labelBgStyle: {fill: '#FEE2AA'},
  labelStyle: {fontSize: 12},
};

// Copied from SmartStepEdge
const stepConfiguration: SmartEdgeOptions = {
  drawEdge: svgDrawStraightLinePath,
  generatePath: pathfindingJumpPointNoDiagonal,
  fallback: BezierEdge,
};
const config = [10, 5];

const useIsIncidentToSelectedNode = (source: string, target: string): boolean =>
  useProzessEditorStore((state) => {
    let sourceSelected = false;
    let targetSelected = false;
    for (const node of state.nodes) {
      if (node.id === source) sourceSelected = !!node.selected;
      if (node.id === target) targetSelected = !!node.selected;
    }
    return sourceSelected || targetSelected;
  });

/**
 * Komponente für eine intelligente Prozesskante mit spezieller Pfadfindung und Darstellung.
 * Hebt die Kante hervor, wenn einer der verbundenen Schritte ausgewählt ist.
 * @param props Eigenschaften der Kante
 */
export const KommunalappSmartProzessEdge: FC<KommunalappProzessEdgeProps> =
  memo((props) => {
    const labelExists = props.label != null;
    const {style, source, target} = props;
    const isIncidentToSelectedNode = useIsIncidentToSelectedNode(
      source,
      target,
    );

    const nodes = useNodes();

    const edge = getSmartEdge({
      ...props,
      nodes,
      options: stepConfiguration,
    });

    const appliedStyle = useMemo(
      () =>
        isIncidentToSelectedNode ? {...style, ...selectedEdgeStyle} : style,
      [isIncidentToSelectedNode, style],
    );

    const {
      sourceX: _sx,
      sourceY: _sy,
      targetX: _tx,
      targetY: _ty,
      sourcePosition: _sp,
      targetPosition: _tp,
      sourceHandleId: _sh,
      targetHandleId: _th,
      pathOptions: _po,
      animated: _a,
      selectable: _se,
      deletable: _de,
      ...baseEdgeProps
    } = props;

    const edgeComp = edge?.svgPathString ? (
      <BaseEdge
        {...baseEdgeProps}
        {...edgeLabelStyling}
        path={edge.svgPathString}
        labelX={edge.edgeCenterX}
        labelY={edge.edgeCenterY}
        style={appliedStyle}
      />
    ) : (
      <SmartStepEdge
        type={undefined}
        {...props}
        {...edgeLabelStyling}
        style={appliedStyle}
        labelBgPadding={[config[0], config[1]]}
        animated={props.animated}
        data={props.data}
        selected={props.selected}
        selectable={props.selectable}
        deletable={props.deletable}
      />
    );

    const {automatisierung} = props.data as {automatisierung: boolean};

    return (
      <>
        {edgeComp}
        {labelExists && (
          <EdgeLabelRenderer>
            <div
              className='edge-label-renderer__custom-edge nodrag nopan heute absolute -top-4 rounded-full border bg-white px-2 text-center text-xs'
              style={{
                transform: `translate(-50%, -50%) translate(${edge?.edgeCenterX}px,${edge?.edgeCenterY}px)`,
              }}
            >
              {automatisierung ? 'Automatisierung' : 'Button'}
            </div>
          </EdgeLabelRenderer>
        )}
      </>
    );
  });

KommunalappSmartProzessEdge.displayName = 'KommunalappSmartProzessEdge';

/**
 * Komponente für eine Bezier-Prozesskante mit Hervorhebung, wenn einer der verbundenen
 * Schritte ausgewählt ist. Zeigt optional ein Label mit dem Status der Automatisierung an.
 * @param props Eigenschaften der Kante
 */
export const KommunalappBezierProzessEdge: FC<KommunalappProzessEdgeProps> =
  memo((props) => {
    const [edgePath, labelX, labelY] = getBezierPath(props);

    const labelExists = props.label != null;
    const {style, source, target} = props;
    const isIncidentToSelectedNode = useIsIncidentToSelectedNode(
      source,
      target,
    );

    const appliedStyle = useMemo(
      () =>
        isIncidentToSelectedNode ? {...style, ...selectedEdgeStyle} : style,
      [isIncidentToSelectedNode, style],
    );

    const {
      sourceX: _sx,
      sourceY: _sy,
      targetX: _tx,
      targetY: _ty,
      sourcePosition: _sp,
      targetPosition: _tp,
      sourceHandleId: _sh,
      targetHandleId: _th,
      pathOptions: _po,
      animated: _a,
      selectable: _se,
      deletable: _de,
      ...bezierBaseEdgeProps
    } = props;

    const {automatisierung} = props.data as {automatisierung: boolean};

    return (
      <>
        <BaseEdge
          {...bezierBaseEdgeProps}
          {...edgeLabelStyling}
          path={edgePath}
          labelX={labelX}
          labelY={labelY}
          style={appliedStyle}
        />
        {labelExists && (
          <EdgeLabelRenderer>
            <div
              className='edge-label-renderer__custom-edge nodrag nopan heute absolute -top-4 rounded-full border bg-white px-2 text-center text-xs'
              style={{
                transform: `translate(-50%, -50%) translate(${labelX}px,${labelY}px)`,
              }}
            >
              {automatisierung ? 'Automatisierung' : 'Button'}
            </div>
          </EdgeLabelRenderer>
        )}
      </>
    );
  });

KommunalappBezierProzessEdge.displayName = 'KommunalappBezierProzessEdge';

/**
 * Single edge type registered with React Flow. The Eckige/Runde-Kanten choice is read from
 * the store here rather than by swapping the `edgeTypes` object, because a changed
 * `edgeTypes` reference makes React Flow rebuild every edge and emit error #002.
 */
export const KommunalappProzessEdge: FC<KommunalappProzessEdgeProps> = memo(
  (props) => {
    const smartEdges = useProzessEditorStore((state) => state.smartEdges);
    return smartEdges ? (
      <KommunalappSmartProzessEdge {...props} />
    ) : (
      <KommunalappBezierProzessEdge {...props} />
    );
  },
);

KommunalappProzessEdge.displayName = 'KommunalappProzessEdge';
