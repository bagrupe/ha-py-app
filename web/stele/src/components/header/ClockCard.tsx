import {useEffect, useState} from 'react';
import {
  longDateFormatter,
  timeFormatter,
  weekdayFormatter,
} from '../../utils/timeUtils';
import AnalogClock from './AnalogClock';

export default function ClockCard() {
  // Initialize with current time
  const [time, setTime] = useState(new Date());

  useEffect(() => {
    // Update state every minute
    const timer = setInterval(() => {
      setTime(new Date());
    }, 60 * 1000);

    // Cleanup interval on unmount to prevent memory leaks
    return () => clearInterval(timer);
  }, []);

  return (
    <div className='flex h-full w-[300px] shrink-0 items-center gap-2 rounded-[10px] bg-gray-50 px-5 py-4 shadow-[0_0_3px_0_rgba(0,0,0,0.25)]'>
      {/* <ClockPlaceholder /> */}
      <AnalogClock time={time} />
      <div className='flex h-full flex-1 flex-col justify-between py-4 pl-4 text-base text-hameln-675'>
        <div className='flex flex-col gap-1'>
          <p className='font-bold leading-none'>
            {weekdayFormatter.format(time)},
          </p>
          <p className='leading-none'>{longDateFormatter.format(time)}</p>
        </div>
        <p className='text-left leading-none'>
          {timeFormatter.format(time)} Uhr
        </p>
      </div>
    </div>
  );
}
