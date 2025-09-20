import React, { Fragment, useState, useEffect } from 'react';
import { Dialog, Transition, RadioGroup } from '@headlessui/react';
import { useLocales } from '../../providers/LocaleProvider';
import { fetchNui } from '../../utils/fetchNui';
import { If, Then } from 'react-if';
import { TruckRentalData } from '../../types';
import useSound from 'use-sound';
import clickSfx from '@assets/sounds/gtadecline.wav';
import clickSfx2 from '@assets/sounds/gtaselect.mp3';
import hoverSfx from '@assets/sounds/hover.ogg';
import { useTruckRentalData } from '../../state/rental';

const TruckRentalList: React.FC<any> = ({ isShowTruckRental, setTruckRentalOpen }) => {
  const { locale } = useLocales();
  const truckRentalData = useTruckRentalData();
  const [selected, setSelected] = useState<TruckRentalData>({
    id: '',
    title: '',
    description: '',
  });
  const [rentalId, setRentalId] = useState<string>('');

  const [playClick] = useSound(clickSfx, { volume: 0.25 });
  const [playClick2] = useSound(clickSfx2, { volume: 0.25 });
  const [playHover] = useSound(hoverSfx, { volume: 0.25 });

  function closeModal(confirm = false) {
    if (confirm) {
      fetchNui('navigateTruckRental', {
        rentalId: rentalId,
      });
      playClick2();
    } else {
      playClick();
    }

    setSelected({
      id: '',
      title: '',
      description: '',
    });
    
    setTruckRentalOpen(false);
  }

  return (
    <>
      <Transition appear show={isShowTruckRental} as={Fragment}>
        <Dialog as="div" className="relative z-10" onClose={closeModal}>
          <Transition.Child
            as={Fragment}
            enter="ease-out duration-300"
            enterFrom="opacity-0"
            enterTo="opacity-100"
            leave="ease-in duration-200"
            leaveFrom="opacity-100"
            leaveTo="opacity-0"
          >
            <div className="fixed inset-0 bg-purple bg-cover" />
          </Transition.Child>
          <div className="fixed inset-0 z-10 w-screen">
            <div className="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0">
              <Transition.Child
                as={Fragment}
                enter="ease-out duration-300"
                enterFrom="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
                enterTo="opacity-100 translate-y-0 sm:scale-100"
                leave="ease-in duration-200"
                leaveFrom="opacity-100 translate-y-0 sm:scale-100"
                leaveTo="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
              >
                <Dialog.Panel className="relative transform rounded-lg bg-purple2 text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-xl">
                  <div className="bg-black/60 px-4 pb-4 pt-5 sm:p-6 sm:pb-4">
                    <div className="mt-3 text-center sm:ml-4 sm:mt-0 sm:text-left">
                      <Dialog.Title as="h3" className="text-xl font-semibold leading-6 text-green-300">
                        {locale.truck_rental_locations}
                      </Dialog.Title>
                      <div className="w-full px-4 py-4">
                        <RadioGroup
                          value={selected}
                          onChange={(item) => {
                            setSelected(item);
                            setRentalId(item.id);
                            playHover();
                          }}
                        >
                          <div className="space-y-2">
                            {truckRentalData.map((item) => (
                              <RadioGroup.Option
                                key={item.id}
                                value={item}
                                className={({ active, checked }) =>
                                  `${checked ? 'bg-green-900/75 text-white' : 'bg-white'}
                                      relative flex cursor-pointer rounded-lg px-5 py-4 shadow-md focus:outline-none`
                                }
                              >
                                {({ active, checked }) => (
                                  <div className="flex w-full items-center justify-between">
                                    <div className="flex items-center">
                                      <div className="text-md">
                                        <RadioGroup.Label
                                          as="p"
                                          className={`font-medium  ${checked ? 'text-white' : 'text-gray-900'}`}
                                        >
                                          <b>{item.title}</b>
                                        </RadioGroup.Label>
                                        <RadioGroup.Description
                                          as="span"
                                          className={`inline ${checked ? 'text-green-100' : 'text-gray-500'}`}
                                        >
                                          <span>{item.description}</span>
                                        </RadioGroup.Description>
                                      </div>
                                    </div>
                                    {checked && (
                                      <div className="shrink-0 text-white">
                                        <CheckIcon className="h-6 w-6" />
                                      </div>
                                    )}
                                  </div>
                                )}
                              </RadioGroup.Option>
                            ))}
                          </div>
                          <div className="sm:px-auto pt-3 sm:flex sm:flex-row-reverse">
                            <If condition={selected && selected.id !== ''}>
                              <Then>
                                <button
                                  type="button"
                                  className="text-md inline-flex w-full justify-center rounded-md bg-green-600 px-3 py-2 font-semibold text-white shadow-sm outline-none hover:bg-green-700 sm:ml-3 sm:w-auto"
                                  onClick={() => closeModal(true)}
                                >
                                  {locale.navigate}
                                </button>
                              </Then>
                            </If>
                            <button
                              type="button"
                              className="text-md inline-flex w-full justify-center rounded-md bg-white px-3 py-2 font-semibold text-gray-900 shadow-sm outline-none hover:bg-gray-200 sm:ml-3 sm:w-auto"
                              onClick={() => closeModal()}
                            >
                              {locale.exit}
                            </button>
                          </div>
                        </RadioGroup>
                      </div>
                    </div>
                  </div>
                </Dialog.Panel>
              </Transition.Child>
            </div>
          </div>
        </Dialog>
      </Transition>
    </>
  );
};

export default TruckRentalList;

function CheckIcon(props: any) {
  return (
    <svg viewBox="0 0 24 24" fill="none" {...props}>
      <circle cx={12} cy={12} r={12} fill="#fff" opacity="0.2" />
      <path d="M7 13l3 3 7-7" stroke="#fff" strokeWidth={1.5} strokeLinecap="round" strokeLinejoin="round" />
    </svg>
  );
}
