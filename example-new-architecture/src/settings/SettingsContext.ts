import { createContext } from 'react';

export type Theme = 'light' | 'dark';

export type WalletPaymentsConfig = {
  applePayMerchantId: string;
  gPayMerchantId: string;
  gPayGatewayMerchantId: string;
};

type SettingsContextData = {
  theme: Theme;
  setTheme: (theme: Theme) => void;
  toggleWalletPaymentsEnabled: () => void;
  walletPaymentsConfig: WalletPaymentsConfig | undefined;
};

export default createContext<SettingsContextData>({
  theme: 'light',
  setTheme: () => {},
  toggleWalletPaymentsEnabled: () => {},
  walletPaymentsConfig: undefined,
});
