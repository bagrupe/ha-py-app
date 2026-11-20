import {type RouteObject} from 'react-router';
import SwaggerUI from 'swagger-ui-react';
import 'swagger-ui-react/swagger-ui.css';
import {model} from './refs/models';
import {parameters} from './refs/parameters';
import swaggerJson from './swagger.json';

export const apiDocsRoute: RouteObject = {
  path: 'docs-api',
  element: <SwaggerUI spec={{...swaggerJson, ...model, ...parameters}} />,
};
