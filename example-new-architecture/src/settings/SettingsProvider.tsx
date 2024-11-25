import React, { useState, type FC, type PropsWithChildren } from 'react';
import SettingsContext, {
  type Theme,
  type WalletPaymentsConfig,
} from './SettingsContext';

type SettingsProviderProps = PropsWithChildren<{}>;

const SettingsProvider: FC<SettingsProviderProps> = (props) => {
  const { children } = props;
  const [theme, setTheme] = useState<Theme>('light');
  const [walletPaymentsEnabled, setWalletPaymentsEnabled] = useState(true);

  const toggleWalletPaymentsEnabled = () => {
    setWalletPaymentsEnabled((enabled) => !enabled);
  };

  const walletPaymentsConfig: WalletPaymentsConfig | undefined =
    !walletPaymentsEnabled
      ? undefined
      : {
          applePayMerchantId: 'merchant.ApplePay.id.test',
          gPayMerchantId: 'dojo',
          gPayGatewayMerchantId: 'merchant.GPay.gateway.test',
        };

  return (
    <SettingsContext.Provider
      value={{
        theme,
        setTheme,
        toggleWalletPaymentsEnabled,
        walletPaymentsConfig,
      }}
    >
      {children}
    </SettingsContext.Provider>
  );
};

export default SettingsProvider;
