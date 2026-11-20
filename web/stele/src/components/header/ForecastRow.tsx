import {useLocationContext} from '../../context/location-context';
import {dayLabel} from '../../utils/timeUtils';

const weatherIconUrl = (icon: string) =>
  `https://openweathermap.org/img/wn/${icon}@2x.png`;

const WeatherCard = ({
  label,
  icon,
  minTemp,
  maxTemp,
}: {
  label: string;
  icon?: string;
  minTemp?: number;
  maxTemp?: number;
}) => (
  <article className='flex h-full flex-1 flex-col items-center justify-between rounded-[10px] bg-gray-50 p-2 shadow-[0_0_3px_0_rgba(0,0,0,0.25)]'>
    <p className='text-base font-bold leading-none text-hameln-675'>{label}</p>
    <div className='flex flex-col items-center gap-[21px]'>
      {icon ? (
        <img
          alt=''
          src={weatherIconUrl(icon)}
          className='size-[50px] object-contain'
        />
      ) : (
        <div aria-hidden className='size-[50px] rounded bg-hameln-50' />
      )}
      <p className='text-base leading-none text-hameln-675'>
        {minTemp !== undefined && maxTemp !== undefined
          ? `${Math.round(minTemp)}° | ${Math.round(maxTemp)}°`
          : '—'}
      </p>
    </div>
  </article>
);

export default function ForecastRow() {
  const {forecast} = useLocationContext();
  const today = new Date();

  return (
    <div className='flex h-full flex-1 items-stretch gap-6'>
      {[0, 1, 2].map((offset) => {
        const day = forecast[offset];
        const date =
          day?.date ?? new Date(today.getTime() + offset * 86_400_000);
        return (
          <WeatherCard
            key={offset}
            label={dayLabel(date, offset)}
            icon={day?.icon ?? undefined}
            minTemp={day?.minTemp ?? undefined}
            maxTemp={day?.maxTemp ?? undefined}
          />
        );
      })}
    </div>
  );
}
