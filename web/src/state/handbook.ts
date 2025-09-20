import { atom, useAtomValue, useSetAtom, useAtom } from 'jotai';

import { TruckerHandbook } from '../types';


const truckerHandbook = atom<TruckerHandbook>({
    title: '',
    handbook: [],
});

export const useHandbookData = () => useAtomValue(truckerHandbook);
export const useSetHandbookData = () => useSetAtom(truckerHandbook);
export const useHandbookDataState = () => useAtom(truckerHandbook);