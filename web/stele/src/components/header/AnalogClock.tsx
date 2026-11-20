const AnalogClock = (props: {time: Date}) => {
  const hours = props.time.getHours();
  const minutes = props.time.getMinutes();

  // Rotations
  const hourDegrees = (hours % 12) * 30 + minutes * 0.5;
  const minuteDegrees = minutes * 6;

  return (
    <div className='relative aspect-square h-full shrink-0 rounded-full border border-hameln-675/30 bg-hameln-50'>
      {/* Centering Container: 
         Using a flex container for the hands to ensure they 
         all pivot from the exact dead-center of the parent.
      */}
      <div className='absolute inset-0 flex items-center justify-center'>
        {/* Center Pivot Point */}
        <div className='z-40 size-[4%] rounded-full bg-hameln-675' />

        {/* Hour Hand */}
        <div
          className='absolute z-20 h-1/4 w-[3%] origin-bottom rounded-full bg-hameln-675 transition-transform duration-500 ease-in-out'
          style={{
            transform: `translateY(-50%) rotate(${hourDegrees}deg)`,
          }}
        />

        {/* Minute Hand */}
        <div
          className='absolute z-10 h-2/5 w-[2%] origin-bottom rounded-full bg-hameln-675 transition-transform duration-500 ease-in-out'
          style={{
            transform: `translateY(-50%) rotate(${minuteDegrees}deg)`,
          }}
        />
      </div>
    </div>
  );
};

export default AnalogClock;
