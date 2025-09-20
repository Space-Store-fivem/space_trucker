import { atom, useAtomValue, useSetAtom, useAtom } from 'jotai';

import { VehicleStorage, VehicleRentalInfo, PlayerRentalInfo } from '../types';


const vehicleStorageData = atom<VehicleStorage>({
    vehEntity: 0,
    maxCapacity: 0,
    currentCapacity: 0,
    transType: '',
    storage: []
});

export const useVehicleStorageData = () => useAtomValue(vehicleStorageData);
export const useSetVehicleStorageData = () => useSetAtom(vehicleStorageData);
export const useVehicleStorageDataState = () => useAtom(vehicleStorageData);

const vehicleRentalInfo = atom<VehicleRentalInfo[]>([]);

const playerRentalInfo = atom<PlayerRentalInfo>({
    level: 0,
    money: 0
})

export const useVehicleRentalInfoData = () => useAtomValue(vehicleRentalInfo);
export const useSetVehicleRentalInfoData = () => useSetAtom(vehicleRentalInfo);
export const useVehicleRentalInfoDataState = () => useAtom(vehicleRentalInfo);

export const usePlayerRentalInfoData = () => useAtomValue(playerRentalInfo);
export const useSetPlayerRentalInfoData = () => useSetAtom(playerRentalInfo);
export const usePlayerRentalInfoDataState = () => useAtom(playerRentalInfo);