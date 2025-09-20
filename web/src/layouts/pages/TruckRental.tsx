import React, { Fragment, useState, useEffect } from 'react';
import { Transition } from '@headlessui/react';
import { useLocales } from '../../providers/LocaleProvider';
import { fetchNui } from '../../utils/fetchNui';
import { debugData } from '../../utils/debugData';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import { If, Then, Else, Switch, Case } from 'react-if';
import { PDAVisibilityType, VisibilityType } from '../../utils/enum';
import { getRankImage, getRankLabel } from '../../utils/misc';
import tw from 'tailwind-styled-components';
import useSound from 'use-sound';
import clickSfx from '@assets/sounds/select.mp3';
import hoverSfx from '@assets/sounds/hover.mp3';
import 'react-circular-progressbar/dist/styles.css';

import { usePlayerRentalInfoData, useVehicleRentalInfoData } from '../../state/vehicle';
import { VehicleRentalInfo } from '../../types';
import { useSetVisibility } from '../../state/visibility';

const TruckRental: React.FC = () => {
  const { locale } = useLocales();

  const vehicleList = useVehicleRentalInfoData();
  const playerInfo = usePlayerRentalInfoData();

  const setVisible = useSetVisibility();
  const [playClick] = useSound(clickSfx, { volume: 0.25 });
  const [playHover] = useSound(hoverSfx, { volume: 0.25 });

  const rentVehicle = (vehicle: VehicleRentalInfo) => {
    playClick();
    fetchNui('rentVehicle', {
      vehicle: vehicle,
    });
    setVisible(VisibilityType.None);
  };
  let USDollar = new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
  });

  return (
    <>
      <Transition appear show={true} as={Fragment}>
        <div className="relative z-10 w-[1920px] h-[1080px] flex justify-center items-center">
          <Transition.Child
            as={Fragment}
            enter="ease-out duration-300"
            enterFrom="opacity-0"
            enterTo="opacity-100"
            leave="ease-in duration-200"
            leaveFrom="opacity-100"
            leaveTo="opacity-0"
          >
            <div className="fixed inset-0 bg-main-2 bg-cover" />
          </Transition.Child>
          <div className="fixed inset-0 z-10 flex min-h-full w-full items-center justify-center p-0 text-center">
            <Transition.Child
              as={Fragment}
              enter="ease-out duration-300"
              enterFrom="opacity-0 translate-y-4 translate-y-0 scale-95"
              enterTo="opacity-100 translate-y-0 scale-100"
              leave="ease-in duration-200"
              leaveFrom="opacity-100 translate-y-0 scale-100"
              leaveTo="opacity-0 translate-y-4 translate-y-0 scale-95"
            >
              <div className="relative w-full max-w-6xl transform bg-purple text-left shadow-xl transition-all">
                <div className="p-4">
                  <div className="grid max-h-[60vh] grid-rows-1 overflow-auto">
                    <p className="absolute left-[50%] top-[-2.5vh] m-0 translate-x-[-50%] text-5xl font-bold uppercase italic text-white drop-shadow-xl">
                      {locale.list} <span className="text-yellow-200">{locale.veh_rental}</span>
                    </p>

                    <table className="max-h-[10vh] table-fixed border-separate border-spacing-y-2">
                      <thead className="sticky top-0 h-[2vh] bg-violet-900">
                        <tr className="italic text-white">
                          <th scope="col" className="w-[10%] rounded-bl-md rounded-tl-md py-2"></th>
                          <th scope="col" className="w-10 py-2">
                            {locale.col_veh}
                          </th>
                          <th scope="col" className="w-[15%] py-2">
                            {locale.col_capacity}
                          </th>
                          <th scope="col" className="w-10 py-2">
                            {locale.col_trans_type}
                          </th>
                          <th scope="col" className="w-[20%] py-2">
                            {locale.col_level}
                          </th>
                          <th scope="col" className="w-[10%] py-2">
                            {locale.col_rent_price}
                          </th>
                          <th scope="col" className="w-[7%] rounded-br-md rounded-tr-md py-2"></th>
                        </tr>
                      </thead>
                      <tbody>
                        {vehicleList &&
                          vehicleList.map((veh: VehicleRentalInfo) => {
                            return (
                              <tr className="h-[4rem] bg-black/50 font-medium text-white" key={veh.vehicleHash}>
                                <td scope="col" className="rounded-bl-md rounded-tl-md pl-5">
                                  <img src={veh.image} className="h-10" />
                                </td>
                                <td scope="col">{veh.title}</td>
                                <td scope="col">
                                  {veh.capacity} {locale.units}
                                </td>
                                <td scope="col" className="capitalize">
                                  {veh.transType}
                                </td>
                                <td
                                  scope="col"
                                  className="flex items-center rounded-br-md rounded-tr-md pt-2 align-middle"
                                >
                                  <p>{locale[getRankLabel(veh.level)]}({veh.level})</p>
                                  <img
                                    src={'./images/' + getRankImage(veh.level) + '.svg'}
                                    width="50vw"
                                    className="drop-shadow-sglowhover"
                                  />
                                </td>
                                <td scope="col">{USDollar.format(veh.rentPrice)}</td>
                                <td scope="col" className="rounded-br-md rounded-tr-md align-middle">
                                  <If condition={playerInfo.money < veh.rentPrice || playerInfo.level < veh.level}>
                                    <Then>
                                      <button
                                        disabled
                                        className="rounded px-2 font-bold disabled:bg-black disabled:text-gray-600"
                                      >
                                        {locale.rent_button}
                                      </button>
                                    </Then>
                                    <Else>
                                      <button
                                        onClick={() => {
                                          rentVehicle(veh);
                                        }}
                                        className="rounded bg-yellow-300 px-2 font-bold text-neutral-800 hover:bg-purple-500 hover:text-white disabled:bg-black disabled:text-gray-600"
                                      >
                                        {locale.rent_button}
                                      </button>
                                    </Else>
                                  </If>
                                </td>
                              </tr>
                            );
                          })}
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
            </Transition.Child>
          </div>
        </div>
      </Transition>
    </>
  );
};

export default TruckRental;
