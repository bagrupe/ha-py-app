import type {Meta, StoryObj} from '@storybook/react-vite';
import {useEffect, useState} from 'react';
import {ControlledModal} from './ControlledModal';

const useTimerMock = () => {
  const [timeRemaining, setTimeRemaining] = useState(15);
  const [isActive, setIsActive] = useState(true);

  const resetTimer = () => {
    setTimeRemaining(15);
    setIsActive(true);
  };

  useEffect(() => {
    let interval: ReturnType<typeof setInterval>;

    if (isActive && timeRemaining > 0) {
      interval = setInterval(() => {
        setTimeRemaining((prev) => {
          // Check if we are about to hit zero
          if (prev <= 1) {
            setIsActive(false); // Stop the state here
            return 0;
          }
          return prev - 1;
        });
      }, 1000);
    }

    return () => clearInterval(interval);
  }, [isActive, timeRemaining]); // Removed timeRemaining from dependencies to prevent re-running every second

  return {timeRemaining, isActive, resetTimer, setIsActive};
};

const meta: Meta<typeof ControlledModal> = {
  title: 'Components/ControlledModal',
  component: ControlledModal,
  parameters: {layout: 'fullscreen'},
};

export default meta;
type Story = StoryObj<typeof ControlledModal>;

export const SessionActivityDemo: Story = {
  render: (args) => {
    const {timeRemaining, isActive, resetTimer} = useTimerMock();

    useEffect(() => {
      // Logic: Only reset if the session hasn't completely died
      const handleInteraction = () => {
        if (timeRemaining > 0) resetTimer();
      };

      window.addEventListener('mousemove', handleInteraction);
      window.addEventListener('keydown', handleInteraction);

      return () => {
        window.removeEventListener('mousemove', handleInteraction);
        window.removeEventListener('keydown', handleInteraction);
      };
    }, [timeRemaining, resetTimer]);

    const isTimeoutWindowVisible =
      isActive && timeRemaining <= 10 && timeRemaining > 0;

    return (
      <div className='flex min-w-[400px] flex-col items-center gap-6 rounded-2xl border bg-neutral-50 p-10'>
        {/* 1. Content for ACTIVE state */}
        {isActive ? (
          <div className='flex animate-pulse flex-col items-center'>
            <div className='mb-2 size-3 rounded-full bg-green-500' />
            <p className='font-bold text-green-700'>Session active</p>
            <p className='text-sm text-neutral-500'>
              Remaining time: {timeRemaining}s
            </p>
          </div>
        ) : (
          /* 2. Content for INACTIVE state */
          <div className='flex flex-col items-center'>
            <div className='mb-2 size-3 rounded-full bg-red-500' />
            <p className='font-bold text-red-700'>Session expired</p>
            <button
              onClick={resetTimer}
              className='mt-4 rounded-md bg-blue-600 px-4 py-2 text-sm text-white'
            >
              Restart session
            </button>
          </div>
        )}

        <div className='max-w-[250px] text-center text-xs text-neutral-400'>
          {isActive
            ? 'Move the mouse to reset the timer. The modal appears when it hits 10s.'
            : 'The system has timed out. It is now in an inactive state.'}
        </div>

        <ControlledModal
          {...args}
          open={isTimeoutWindowVisible}
          title='Sind Sie noch da?'
          description={`Da für längere Zeit keine Eingabe erfolgt ist, wird die Anwendung in ${timeRemaining} Sekunden zurückgesetzt. Möchten Sie die Sitzung fortsetzen?`}
          onClickAction={resetTimer}
        />
      </div>
    );
  },
  args: {
    title: 'Sind Sie noch da?',
    buttonText: 'Weiter machen',
  },
};
