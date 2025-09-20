import React from 'react';
import { Switch } from '@headlessui/react';

const SwitchToggle: React.FC<{ enabled: boolean; setEnabled: any }> = ({ enabled, setEnabled }) => {
  return (
    <Switch
      checked={enabled}
      onChange={setEnabled}
      className={`${enabled ? 'bg-purple-900' : 'bg-purple-900'}
          relative inline-flex h-[28px] w-[56px] shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out focus:outline-none focus-visible:ring-2  focus-visible:ring-white/75`}
    >
      <span
        aria-hidden="true"
        className={`${enabled ? 'translate-x-7' : 'translate-x-0 '}
            pointer-events-none inline-block h-[24px] w-[24px] transform rounded-full shadow-lg ring-0 bg-purple-300 transition duration-200 ease-in-out`}
      />
    </Switch>
  );
};

export default SwitchToggle;
