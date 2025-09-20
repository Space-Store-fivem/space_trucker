import { atom, useAtomValue, useSetAtom, useAtom } from 'jotai';

import { TruckRentalData } from '../types';


const truckRentalData = atom<TruckRentalData[]>([]);

export const useTruckRentalData = () => useAtomValue(truckRentalData);
export const useSetTruckRentalData = () => useSetAtom(truckRentalData);
export const useTruckRentalDataState = () => useAtom(truckRentalData);