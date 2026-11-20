import {useRouteError} from 'react-router';

/**
 * Komponente zur Anzeige einer Fehlerseite.
 * Zeigt die Fehlerdetails, die durch den Router bereitgestellt werden.
 */
export const ErrorPage = () => {
  const error = useRouteError() as {
    status?: number;
    statusText?: string;
    internal?: boolean;
    data?: string;
    message?: string;
  };

  return (
    <div className='container mx-auto mt-16'>
      <h1 className='mb-4 text-xl font-bold'>Fehler</h1>
      <pre>{JSON.stringify(error, null, 2)}</pre>
    </div>
  );
};
