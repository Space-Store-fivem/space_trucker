import React, { Fragment, useState, useEffect } from 'react';
import { useLocales } from '../../providers/LocaleProvider';
import tw from 'tailwind-styled-components';
import 'react-circular-progressbar/dist/styles.css';
import { getRankImage, getRankLabel } from '../../utils/misc';
import { VehicleCapacity } from '../../types';

const VehicleCapacityList: React.FC<any> = ({ vehicleList }) => {
  const { locale } = useLocales();

  return (
    <>
      <div className="mt-5 flex flex-col overflow-auto">
        <p className="absolute left-[50%] top-[7.8vh] m-0 translate-x-[-50%] text-3xl font-bold uppercase italic text-white drop-shadow-xl">
          {locale.list} <span className="text-yellow-200">{locale.veh_capacity}</span>
        </p>
        <table className="max-h-[10vh] xl:mt-5 table-fixed border-separate border-spacing-y-2">
          <thead className="sticky top-0 h-[2vh] bg-violet-900">
            <tr className="italic text-white">
              <th scope="col" className="w-10 rounded-bl-md rounded-tl-md py-2"></th>
              <th scope="col" className="w-10 py-2">
                {locale.col_veh}
              </th>
              <th scope="col" className="w-10 py-2">
                {locale.col_capacity}
              </th>
              <th scope="col" className="w-10 py-2">
                {locale.col_trans_type}
              </th>
              <th scope="col" className="w-10 rounded-br-md rounded-tr-md py-2">
                {locale.col_level}
              </th>
            </tr>
          </thead>
          <tbody>
            {vehicleList &&
              vehicleList.map((veh: VehicleCapacity) => {
                return (
                  <tr className="h-[4rem] bg-black/50 font-medium text-white" key={veh.name}>
                    <td scope="col" className="rounded-bl-md rounded-tl-md pl-5">
                      <img src={veh.image} className="h-10" />
                    </td>
                    <td scope="col">{veh.name}</td>
                    <td scope="col">
                      {veh.capacity} {locale.units}
                    </td>
                    <td scope="col" className="capitalize">
                      {veh.transType}
                    </td>
                    <td scope="col" className="flex items-center rounded-br-md rounded-tr-md pt-2 align-middle">
                      <p>{locale[getRankLabel(veh.level)]}({veh.level})</p>
                      <img
                        src={'./images/' + getRankImage(veh.level) + '.svg'}
                        width="50vw"
                        className="drop-shadow-sglowhover"
                      />
                    </td>
                  </tr>
                );
              })}
          </tbody>
        </table>
      </div>
    </>
  );
};

export default VehicleCapacityList;
