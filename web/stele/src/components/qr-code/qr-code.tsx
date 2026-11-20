import {QRCodeSVG} from 'qrcode.react';

type QrCodeCommonProps = {
  label?: string;
  size?: number;
  className?: string;
};

type QrCodeProps =
  | (QrCodeCommonProps & {value: string; src?: never})
  | (QrCodeCommonProps & {src: string; value?: never});

export const QrCode = ({
  value,
  src,
  label,
  size = 64,
  className,
}: QrCodeProps) => (
  <div className={`flex flex-col items-center gap-1 ${className ?? ''}`}>
    <div
      className='flex items-center justify-center rounded-[4px] bg-white drop-shadow-[0_0_1.5px_rgba(0,0,0,0.25)]'
      style={{width: size, height: size}}
    >
      {src ? (
        <img src={src} alt='' width={size - 12} height={size - 12} />
      ) : (
        <QRCodeSVG
          value={value as string}
          size={size - 12}
          bgColor='#ffffff'
          fgColor='#000000'
          level='M'
          marginSize={0}
        />
      )}
    </div>
    {label && (
      <p className='whitespace-nowrap text-[12px] leading-normal text-[#4e4e4e]'>
        {label}
      </p>
    )}
  </div>
);
