import { useContext } from 'react';
import SettingsContext from './SettingsContext';

const useSettings = () => {
  return useContext(SettingsContext);
};

export default useSettings;
