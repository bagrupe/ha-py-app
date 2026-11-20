import TouchButtonIcon from '../components/icons/TouchButtonIcon';

export default function InactiveStateText(props: {
  buttonAction?: () => void;
  className?: string;
}) {
  return (
    <div
      className={`flex w-full flex-row justify-between gap-x-6 py-16 ${props.className}`}
    >
      <p>
        <span className='font-bold text-hameln-675'>
          Ihr digitaler Infopunkt:{' '}
        </span>
        Entdecke aktuelle Highlights und lokale News direkt hier oder mobil in
        unserer App.
      </p>

      <button
        className='flex min-w-fit flex-row gap-x-2 rounded-[10px] bg-hameln-600 p-4 text-white'
        aria-label='Bildschirm berühren'
        onClick={props.buttonAction}
      >
        <TouchButtonIcon aria-hidden />
        Bildschirm berühren
      </button>
    </div>
  );
}
