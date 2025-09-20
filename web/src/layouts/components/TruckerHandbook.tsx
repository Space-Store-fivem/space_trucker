import React, { Fragment, useState, useEffect } from 'react';
import { Dialog, Transition, Disclosure } from '@headlessui/react';
import { useLocales } from '../../providers/LocaleProvider';
import { useHandbookData } from '../../state/handbook';
import useSound from 'use-sound';

import clickSfx from '@assets/sounds/gtadecline.wav';
const TruckerHandbook: React.FC<any> = ({ isTruckerHandbook, setHandbookIsOpen }) => {
  const { locale } = useLocales();
  const handbookData = useHandbookData();
  const [playClick] = useSound(clickSfx, { volume: 0.25 });

  function closeModal() {
    playClick();
    setHandbookIsOpen(false);
  }
  return (
    <>
      <Transition appear show={isTruckerHandbook} as={Fragment}>
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
                <Dialog.Panel className="relative transform rounded-lg bg-purple2 text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-3xl">
                  <div className="max-h-[60vh] overflow-auto rounded-md bg-black/60 px-4 pb-4 pt-5 sm:p-6 sm:pb-4">
                    <div className="mt-3 text-center sm:ml-4 sm:mt-0 sm:text-left">
                      <Dialog.Title as="h3" className="text-2xl font-semibold leading-6 text-green-300">
                        {handbookData.title}
                      </Dialog.Title>
                      {handbookData.handbook.map((item, index) => {
                        return (
                          <div className="mt-3" key={index}>
                            <Disclosure>
                              {({ open }) => (
                                <>
                                  <Disclosure.Button className="flex w-full justify-between rounded-lg bg-purple-100 px-4 py-2 text-left text-xl font-medium text-purple-900 hover:bg-purple-200 focus:outline-none focus-visible:ring focus-visible:ring-purple-500/75">
                                    <span>{item.title}</span>
                                  </Disclosure.Button>
                                  <Disclosure.Panel className="px-4 pb-2 pt-4 text-xl text-gray-100">
                                    {item.description}
                                  </Disclosure.Panel>
                                </>
                              )}
                            </Disclosure>
                          </div>
                        );
                      })}
                    </div>
                  </div>
                  <div className="sm:px-auto bg-black/50 px-4 py-3 sm:flex sm:flex-row-reverse">
                    <button
                      type="button"
                      className="inline-flex w-full justify-center rounded-md bg-white px-3 py-2 text-xl font-semibold text-gray-900 shadow-sm outline-none hover:bg-gray-200 sm:ml-3 sm:w-auto"
                      onClick={() => closeModal()}
                    >
                      {locale.exit}
                    </button>
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

export default TruckerHandbook;
