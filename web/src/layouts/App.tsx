// gs_trucker/web/src/layouts/App.tsx

import { useNuiEvent } from '../hooks/useNuiEvent';
import React, { useEffect, useState } from 'react';
import { fetchNui } from '../utils/fetchNui';
import { Switch, Case } from 'react-if';
import { isEnvBrowser } from '../utils/misc';
import { PDAVisibilityType, VisibilityType } from '../utils/enum';
import { useSetModalData } from '../state/modal';
import { useSetPlayerRentalInfoData, useSetVehicleRentalInfoData, useSetVehicleStorageData } from '../state/vehicle';
import {
  ModalData, VehicleStorage, TrukerData, PDAData, CarryData, VehicleRentalInfo, PlayerRentalInfo, FullCompanyInfo,
} from '../types';
import IndustryModal from './components/IndustryModal';
import VehicleStorageComp from './components/VehicleStorage';
import TruckerPDA from './pages/TruckerPDA';
import { useSetCarryData, useSetPDAData, useSetTruckerData } from '../state/pda';
import TruckRental from './pages/TruckRental';
import CompanyPanel from './pages/company/CompanyPanel';
import { useSetPDAVisibility, useVisibilityState } from '../state/visibility';
import GarageMenu from './GarageMenu';

export const App: React.FC = () => {
  const [visible, setVisible] = useVisibilityState();
  const setVehicleStorageData = useSetVehicleStorageData();
  const setModalData = useSetModalData();
  const setTruckerData = useSetTruckerData();
  const setPDAData = useSetPDAData();
  const setCarryData = useSetCarryData();
  const setVehicleRentalInfo = useSetVehicleRentalInfoData();
  const setPlayerRentalInfo = useSetPlayerRentalInfoData();
  const setPDAVisible = useSetPDAVisibility();
  const [toggleModalConfirm, setToggleModalConfirm] = useState(true);
  const [zoomLevel, setZoomLevel] = useState(1.0);
  
  // Estados para os dois painéis principais
  const [showCompanyPanel, setShowCompanyPanel] = useState(false);
  const [companyData, setCompanyData] = useState<FullCompanyInfo | null>(null);
  const [garageVisible, setGarageVisible] = useState<boolean>(false);
  const [garageVehicles, setGarageVehicles] = useState<any[]>([]);

  // Função para atualizar os dados da empresa (necessária para o CompanyPanel)
  const updateCompanyData = (newData: FullCompanyInfo) => {
    setCompanyData(newData);
  };

  const handleClosePanels = () => {
    if (showCompanyPanel) {
        if (!isEnvBrowser()) {
            fetchNui('closePanel');
        }
        setShowCompanyPanel(false);
        setCompanyData(null);
    }
  };

  const handleCloseGarage = () => {
    setGarageVisible(false);
    fetchNui('gs_trucker:garage_close');
  }

  // Listener para o painel da empresa
  useNuiEvent<FullCompanyInfo>('showCompanyPanel', (data) => {
    setCompanyData(data);
    setShowCompanyPanel(true);
    setVisible(VisibilityType.None); 
  });

  // Listener para o menu da garagem
  useNuiEvent<{ show: boolean, vehicles: any[] }>('showGarage', (data) => {
    setGarageVehicles(data.vehicles || []);
    setGarageVisible(data.show);
  });

  useNuiEvent(
    'sendTruckerPDA',
    (data: { truckerData: TrukerData; pdaData: PDAData; carryData: CarryData; isToggleModalConfirm: boolean }) => {
      setTruckerData(data.truckerData);
      setPDAData(data.pdaData);
      setCarryData(data.carryData);
      setToggleModalConfirm(data.isToggleModalConfirm);
      setVisible(VisibilityType.TruckerPDA);
      setShowCompanyPanel(false);
    }
  );

  useNuiEvent('sendIndustryModal', (data: { modalData: ModalData }) => {
    setModalData(data.modalData);
    setVisible(VisibilityType.Modal);
  });

  useNuiEvent('sendVehicleStorage', (data: { vehicleStorage: VehicleStorage }) => {
    setVehicleStorageData(data.vehicleStorage);
    setVisible(VisibilityType.VehicleStorage);
  });

  useNuiEvent(
    'sendTruckRentalMenu',
    (data: { truckRentalInfo: VehicleRentalInfo[]; playerRentalInfo: PlayerRentalInfo }) => {
      setVehicleRentalInfo(data.truckRentalInfo);
      setPlayerRentalInfo(data.playerRentalInfo);
      setVisible(VisibilityType.TruckRentalMenu);
    }
  );

  useEffect(() => {
    const keyHandler = (e: KeyboardEvent) => {
        if (['Escape'].includes(e.code)) {
            const isOldUIVisible = visible !== VisibilityType.None;
            
            if (garageVisible) {
                handleCloseGarage();
            } else if (isOldUIVisible) {
                if (!isEnvBrowser()) {
                    fetchNui('hideFrame', { visibleType: visible, proceed: false });
                }
                setPDAVisible(PDAVisibilityType.Statics);
                setVisible(VisibilityType.None);
            } else if (showCompanyPanel) {
                handleClosePanels();
            }
        } else if (visible === VisibilityType.TruckerPDA && ['Backspace'].includes(e.code)) {
            setPDAVisible(PDAVisibilityType.Statics);
        }
    };

    window.addEventListener('keydown', keyHandler);
    return () => window.removeEventListener('keydown', keyHandler);
  }, [visible, showCompanyPanel, garageVisible, setVisible, setPDAVisible]);


  const handleResize = () => {
    var zoomCountOne = document.body.clientWidth / 1920;
    var zoomCountTwo = document.body.clientHeight / 1080;

    if (zoomCountOne < zoomCountTwo) setZoomLevel(zoomCountOne);
    else setZoomLevel(zoomCountTwo);
  }
  
  useEffect(() => {
  }, [zoomLevel])
  
  useEffect(() => {
    const isAnyUIVisible = visible !== VisibilityType.None || showCompanyPanel || garageVisible;
    if (!isAnyUIVisible) return;
    
    handleResize();
    window.addEventListener("resize", handleResize);

    return () => window.removeEventListener("resize", handleResize);
  }, [visible, showCompanyPanel, garageVisible]);

  return (
    <section style={{zoom: zoomLevel}}>
      <Switch>
        <Case condition={visible === VisibilityType.Modal}>
          <IndustryModal />
        </Case>
        <Case condition={visible === VisibilityType.VehicleStorage}>
          <VehicleStorageComp />
        </Case>
        <Case condition={visible === VisibilityType.TruckerPDA}>
          <TruckerPDA toggleModal={toggleModalConfirm} />
        </Case>
        <Case condition={visible === VisibilityType.TruckRentalMenu}>
          <TruckRental />
        </Case>
      </Switch>

      {/* A lógica de renderização agora está correta para ambos os painéis */}
      {showCompanyPanel && companyData && <CompanyPanel data={companyData} updateCompanyData={updateCompanyData} />}
      
      {garageVisible && <GarageMenu vehicles={garageVehicles} onClose={handleCloseGarage} />}
    </section>
  );
};
