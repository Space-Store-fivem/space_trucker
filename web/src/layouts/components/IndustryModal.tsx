import React, { Fragment, useState, useEffect } from 'react';
import { Dialog, Transition } from '@headlessui/react';
import { useLocales } from '../../providers/LocaleProvider';
import { fetchNui } from '../../utils/fetchNui';
import { If, Then, Else } from 'react-if';
import { ModalType, VisibilityType } from '../../utils/enum';
import { useModalData } from '../../state/modal';
import { useVisibilityState } from '../../state/visibility';
import useSound from 'use-sound';

import clickSfx from '@assets/sounds/click.ogg';
const IndustryModal: React.FC = () => {
  const { locale } = useLocales();
  const modalData = useModalData();
  const [value, setValue] = useState(
    modalData.type === ModalType.Dialog && modalData.extraArgs.default ? modalData.extraArgs.default : 0
  );
  const [visible, setVisible] = useVisibilityState();
  const [playClick] = useSound(clickSfx, { volume: 0.25 });

  const onInputChangeValue = (value: number) => {
    if (value < modalData.extraArgs.min) {
      setValue(modalData.extraArgs.min);
      return
    }
    
    if (value > modalData.extraArgs.max) {
      setValue(modalData.extraArgs.max);
      return
    }
    
    setValue(value);
  };

  function closeModal(confirm = false) {
    playClick();
    fetchNui('hideFrame', {
      visibleType: visible,
      modalType: modalData.type,
      confirm: confirm,
      extraArgs: modalData.extraArgs,
      value: value,
    });
    setVisible(VisibilityType.None);
  }
  return (
    <>
      <Transition appear show={true} as={Fragment}>
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
            <div className="fixed inset-0 bg-black/25" />
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
                <Dialog.Panel className="relative transform rounded-lg bg-black/60 text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-xl">
                  <div className="rounded-tl-lg rounded-tr-lg bg-black/60 px-4 pb-4 pt-5 sm:p-6 sm:pb-4">
                    <div className="text-left">
                      <Dialog.Title as="h3" className="text-xl font-semibold leading-6 text-green-300">
                        {modalData.title}
                      </Dialog.Title>
                      <div className="mt-2">
                        <p className="text-md text-white">{modalData.description}</p>
                      </div>
                    </div>
                    <If condition={modalData.type === ModalType.Dialog}>
                      <Then>
                        <div className="mt-4 text-left">
                          <input
                            className="w-full rounded-md bg-neutral-500 p-2 outline-none text-white text-lg"
                            value={value}
                            onChange={(e) => onInputChangeValue(Number(e.target.value))}
                            type={'number'}
                          />
                        </div>
                      </Then>
                    </If>
                  </div>
                  <div className="sm:px-auto rounded-bl-lg rounded-br-lg bg-black/50 px-4 py-3 sm:flex sm:flex-row-reverse">
                    <button
                      type="button"
                      className="text-md inline-flex w-full justify-center rounded-md bg-green-600 px-3 py-2 font-semibold text-white shadow-sm outline-none hover:bg-green-700 sm:ml-3 sm:w-auto"
                      onClick={() => closeModal(true)}
                    >
                      {locale.confirm_buy}
                    </button>
                    <button
                      type="button"
                      className="text-md inline-flex w-full justify-center rounded-md bg-white px-3 py-2 font-semibold text-gray-900 shadow-sm outline-none hover:bg-gray-200 sm:ml-3 sm:w-auto"
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

export default IndustryModal;
