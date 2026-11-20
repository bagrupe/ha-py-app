import {type Meta, type StoryObj} from '@storybook/react';
import {type FC, useState} from 'react';
import {Sidebar, type SidebarProps} from './sidebar.tsx';

const InteractiveSidebar: FC = () => {
  const [open, setOpen] = useState(false);

  return (
    <div className='flex h-[90vh] flex-row'>
      <div className='flex flex-1 items-center justify-center'>
        <button onClick={() => setOpen(true)}>Open Sidebar</button>
      </div>
      <Sidebar isOpen={open}>
        <div className='flex h-full w-[480px] items-center justify-center bg-primary-light'>
          <button onClick={() => setOpen(false)}>Close Sidebar</button>
        </div>
      </Sidebar>
    </div>
  );
};

const config = {
  title: 'Common/Sidebar',
  component: Sidebar,
  args: {
    isOpen: false,
    children: null,
  },
} satisfies Meta<SidebarProps>;

export default config;

export const SidebarStory: StoryObj<typeof config> = {
  name: 'Sidebar',
  render: () => <InteractiveSidebar />,
};
