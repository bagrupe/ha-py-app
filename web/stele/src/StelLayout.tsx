import {Outlet} from 'react-router';
import Header from './components/header/Header';

export const StelLayout = () => (
  <main className='flex min-h-screen flex-col bg-white'>
    <Header className='px-16 pb-6 pt-16' />
    <div className='flex min-h-0 flex-1 flex-col'>
      <Outlet />
    </div>
  </main>
);
