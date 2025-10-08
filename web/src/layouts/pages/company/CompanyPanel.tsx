import React, { useState, useEffect } from 'react';
import { FullCompanyInfo } from '../../../types';
import HomeScreen from './HomeScreen';
import { CreateProfile } from './CreateProfile';
import { CreateCompany } from './CreateCompany';
import { Dashboard } from './Dashboard';
import { Employees } from './Employees';
import Fleet from './Fleet';
import { Finance } from './Finance';
import { Settings } from './Settings';
import { fetchNui } from '../../../utils/fetchNui';
import { RecruitmentAgency } from './RecruitmentAgency';
import { Industries } from './Industries';
import { TransportMissions } from './TransportMissions';
import { LogisticsHub } from './LogisticsHub';
import CompanyGPS from './CompanyGPS';
import { IndustryMonitor } from './IndustryMonitor';
import { ProfileManagement } from './ProfileManagement';
import { CargoPanel } from './CargoPanel';
import CustomizationPanel from './CustomizationPanel';
// ✨ NOVO COMPONENTE IMPORTADO AQUI ✨
import { TrailerGarage } from './TrailerGarage';

const CompanyPanel: React.FC<{ data: FullCompanyInfo; updateCompanyData: (data: FullCompanyInfo) => void; }> = ({ data, updateCompanyData }) => {
  const [activeApp, setActiveApp] = useState(data.has_profile ? 'home' : 'createProfile');

  // Estado inicial com os valores padrão
  const [customization, setCustomization] = useState({
    backgroundColor: '#111827',
    backgroundImage: '',
    blurEnabled: true, 
  });

  const handleRefresh = () => {
    fetchNui('forceRefreshData');
  };

  // ==================================================================
  // ========= ✨ CORREÇÃO APLICADA AQUI ✨ =========
  // ==================================================================
  // Este useEffect agora lê as configurações da propriedade 'data' quando ela chega ou é atualizada.
  useEffect(() => {
    if (data && data.profile_data) {
      setCustomization({
        backgroundColor: data.profile_data.backgroundColor || '#111827',
        backgroundImage: data.profile_data.backgroundImage || '',
        // É importante verificar se o valor é estritamente 'false' (ou 0 no caso do Lua)
        blurEnabled: data.profile_data.blurEnabled !== false && data.profile_data.blurEnabled !== 0,
      });
    }
  }, [data]); // A dependência é a propriedade 'data'

  useEffect(() => {
    if (data.company_data && (activeApp === 'createCompany' || activeApp === 'createProfile')) {
      setActiveApp('home');
    }
    if (!data.company_data && activeApp === 'settings') {
        setActiveApp('home');
    }
    if (data.has_profile && activeApp === 'createProfile') {
        setActiveApp('home');
    }
  }, [data, activeApp]);

  const safeUpdateCompanyData = (newData: Partial<FullCompanyInfo>) => {
    const updatedData = {
      ...data,
      ...newData,
      company_data: { ...(data.company_data || {}), ...(newData.company_data || {}) },
    };
    updateCompanyData(updatedData as FullCompanyInfo);
  };

  const renderActiveApp = () => {
    const goBack = () => setActiveApp('home');
    if (!data.has_profile) return <CreateProfile onSuccess={handleRefresh} />;

    switch (activeApp) {
      case 'home':
        return <HomeScreen company={data.company_data} profile={data.profile_data} isOwner={data.is_owner || false} playerRole={data.player_role} onAppSelect={setActiveApp} />;
      case 'customization':
        return <CustomizationPanel 
                  onClose={goBack} 
                  currentSettings={customization}
                  onSave={(newCustomization) => {
                      setCustomization(newCustomization);
                      fetchNui('space_trucker:save_customization', newCustomization);
                      goBack();
                  }}
              />;
      // ... (outros cases permanecem os mesmos)
      case 'createCompany': return <CreateCompany onSuccess={handleRefresh} onClose={goBack} />;
      case 'dashboard': return <Dashboard companyData={data} onBack={goBack} />;
      case 'recruitment': return <RecruitmentAgency companyData={data} onBack={goBack} />;
      case 'industries': return <Industries companyData={data.company_data!} onBack={goBack} onSuccess={handleRefresh} />;
      case 'missions': return <TransportMissions onBack={goBack} companyData={data} />;
      case 'logisticsHub': return <LogisticsHub onBack={goBack} />;
      case 'gps': return <CompanyGPS onBack={goBack} />;
      case 'employees': return <Employees companyData={data} updateCompanyData={safeUpdateCompanyData} onBack={goBack} />;
      case 'fleet': return <Fleet companyData={data} onBack={goBack} onSuccess={handleRefresh} />;
      case 'finance': return <Finance companyData={data} updateCompanyData={safeUpdateCompanyData} onBack={goBack} />;
      case 'settings': return <Settings companyData={data} updateCompanyData={safeUpdateCompanyData} onBack={goBack} onSuccess={handleRefresh} />;
      case 'industryMonitor': return <IndustryMonitor onBack={goBack} />;
      case 'profile': return <ProfileManagement onBack={goBack} profile={data.profile_data || null} />;
      case 'cargo_panel': return <CargoPanel onBack={goBack} />;
      
      // ✨ NOVA ROTA ADICIONADA AQUI ✨
      case 'trailer_garage': return <TrailerGarage onBack={goBack} />;

      default:
        return <HomeScreen company={data.company_data} profile={data.profile_data} isOwner={data.is_owner || false} playerRole={data.player_role} onAppSelect={setActiveApp} />;
    }
  };
 
  const panelStyle = {
    backgroundColor: customization.backgroundColor,
    backgroundImage: customization.backgroundImage ? `url(${customization.backgroundImage})` : 'none',
    backgroundSize: 'cover',
    backgroundPosition: 'center',
    backgroundRepeat: 'no-repeat',
  };

  return (
    <div className="flex items-center justify-center h-screen w-screen font-sans">
      <div className="relative w-[90vw] h-[90vh] max-w-[1400px] max-h-[900px]">
        <div 
          style={panelStyle}
          className="absolute w-[79.6%] h-[87.5%] top-[5.3%] left-[10%] bg-gray-900 rounded-2xl shadow-inner flex overflow-hidden z-10 transition-all duration-300"
        >
          {/* Esta div de sobreposição aplica o efeito de blur */}
          <div className={`w-full h-full transition-all duration-300 ${customization.blurEnabled ? 'bg-black/40 backdrop-blur-sm' : 'bg-transparent'}`}>
            {renderActiveApp()}
          </div>
        </div>
        <img 
          src="images/ifruit-air.png" 
          alt="Moldura do Tablet" 
          className="absolute top-0 left-0 w-full h-full object-contain z-20 pointer-events-none" 
        />
      </div>
    </div>
  );
}

export default CompanyPanel;

