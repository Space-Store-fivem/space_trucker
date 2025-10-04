// space_trucker/web/src/layouts/App.tsx (VERSÃO FINAL E LIMPA)

import { useNuiEvent } from '../hooks/useNuiEvent';
import React, { useEffect, useState } from 'react';
import { fetchNui } from '../utils/fetchNui';
import { Switch, Case } from 'react-if';
import { isEnvBrowser } from '../utils/misc';
import { VisibilityType } from '../utils/enum';
import { useSetModalData } from '../state/modal';
import { useSetVehicleStorageData } from '../state/vehicle';
import { ModalData, VehicleStorage, FullCompanyInfo } from '../types';
import IndustryModal from './components/IndustryModal';
import VehicleStorageComp from './components/VehicleStorage';
import CompanyPanel from './pages/company/CompanyPanel';
import { useVisibilityState } from '../state/visibility';
import GarageMenu from './GarageMenu';

export const App: React.FC = () => {
  const [visible, setVisible] = useVisibilityState();
  const setVehicleStorageData = useSetVehicleStorageData();
  const setModalData = useSetModalData();
  const [zoomLevel, setZoomLevel] = useState(1.0);

  // Estados para os painéis principais
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
    fetchNui('space_trucker:garage_close');
  };

  // Listener para fechar o painel a partir do lado do cliente
  useNuiEvent<void>('closePanel', () => {
    setShowCompanyPanel(false);
    setCompanyData(null);
  });

  // Listener para mostrar o painel da empresa
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

  // Listeners para os modais que ainda são usados
  useNuiEvent('sendIndustryModal', (data: { modalData: ModalData }) => {
    setModalData(data.modalData);
    setVisible(VisibilityType.Modal);
  });

  useNuiEvent('sendVehicleStorage', (data: { vehicleStorage: VehicleStorage }) => {
    setVehicleStorageData(data.vehicleStorage);
    setVisible(VisibilityType.VehicleStorage);
  });

  // Lógica para fechar os painéis com a tecla 'Escape'
  useEffect(() => {
    const keyHandler = (e: KeyboardEvent) => {
      const isOldUIVisible = visible !== VisibilityType.None;

      if (['Escape'].includes(e.code)) {
        if (garageVisible) {
          handleCloseGarage();
        } else if (isOldUIVisible) {
          if (!isEnvBrowser()) {
            fetchNui('hideFrame', { visibleType: visible, proceed: false });
          }
          setVisible(VisibilityType.None);
        } else if (showCompanyPanel) {
          handleClosePanels();
        }
      }
    };

    window.addEventListener('keydown', keyHandler);
    return () => window.removeEventListener('keydown', keyHandler);
  }, [visible, showCompanyPanel, garageVisible, setVisible]);

  // Lógica para ajustar o zoom da interface
  const handleResize = () => {
    const zoomCountOne = document.body.clientWidth / 1920;
    const zoomCountTwo = document.body.clientHeight / 1080;
    setZoomLevel(zoomCountOne < zoomCountTwo ? zoomCountOne : zoomCountTwo);
  };

  useEffect(() => {
    const isAnyUIVisible = visible !== VisibilityType.None || showCompanyPanel || garageVisible;
    if (!isAnyUIVisible) return;

    handleResize();
    window.addEventListener("resize", handleResize);

    return () => window.removeEventListener("resize", handleResize);
  }, [visible, showCompanyPanel, garageVisible]);

  return (
    <section style={{ zoom: zoomLevel }}>
      <Switch>
        <Case condition={visible === VisibilityType.Modal}>
          <IndustryModal />
        </Case>
        <Case condition={visible === VisibilityType.VehicleStorage}>
          <VehicleStorageComp />
        </Case>
      </Switch>

      {/* Renderiza os painéis principais */}
      {showCompanyPanel && companyData && <CompanyPanel data={companyData} updateCompanyData={updateCompanyData} />}
      {garageVisible && <GarageMenu vehicles={garageVehicles} onClose={handleCloseGarage} />}
    </section>
  );
};