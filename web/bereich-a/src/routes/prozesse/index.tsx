import {type RouteObject} from 'react-router';
import {ProzessEditor} from './prozess-editor/prozess-editor.tsx';

export const prozesseRoute: RouteObject = {
  path: 'prozesse/:id',
  element: <ProzessEditor />,
};
