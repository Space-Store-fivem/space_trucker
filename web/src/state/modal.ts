import { atom, useAtomValue, useSetAtom, useAtom } from 'jotai';

import { ModalData } from '../types';


const modalData = atom<ModalData>({
    type: 0,
    title: '',
    description: '',
    extraArgs: {},
});

export const useModalData = () => useAtomValue(modalData);
export const useSetModalData = () => useSetAtom(modalData);
export const useModalDataState = () => useAtom(modalData);