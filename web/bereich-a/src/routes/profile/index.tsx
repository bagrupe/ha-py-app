import {type RouteObject} from 'react-router';
import {resetPasswordRoute} from './reset-password/reset-password';

export const profileRoutes: RouteObject = {
  path: '/profile',
  children: [resetPasswordRoute],
};
